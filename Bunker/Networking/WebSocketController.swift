//
//  WebSocketController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 15.05.2022.
//

import Combine
import UIKit

final class WebSocketController {
    enum Endpoint: String {
        case base = "ws://rdiscount@94.250.251.166:8080/game?username="
    }

    public static var shared = WebSocketController()

    private let socketSerivce = WebSocketService()
    private let logger = SHLogger.shared

    private var clientID: String?
    
    @Published var waitingRoom: WaitingRoom?
    @Published var connectionStatus: Bool = false
    @Published var gameModel: Game?
    @Published var connectionError: String?
    @Published var kickedPlayer: PlayerKicked?
    @Published var flowError: ErrorMessage?
    
    var waitingRoomRecieved: AnyPublisher<WaitingRoom?, Never> {
        return $waitingRoom.eraseToAnyPublisher()
    }
    var connectionStatusSub: AnyPublisher<Bool, Never> {
        return $connectionStatus.eraseToAnyPublisher()
    }
    var gameModelRecieved: AnyPublisher<Game?, Never> {
        return $gameModel.eraseToAnyPublisher()
    }
    var connectionErrorRecieved: AnyPublisher<String?, Never> {
        return $connectionError.eraseToAnyPublisher()
    }

    var kickedPlayerRecieved: AnyPublisher<PlayerKicked?, Never> {
        return $kickedPlayer.eraseToAnyPublisher()
    }

    var florErrorRecieved: AnyPublisher<ErrorMessage?, Never> {
        return $flowError.eraseToAnyPublisher()
    }

    private init() {
        socketSerivce.delegate = self
    }

    public func connectToGame(username: String, roomCode: String? , isCreator: Bool) {
        var base = Endpoint.base.rawValue
        base += username
        base += "&isCreator=\(isCreator)"
        if let code = roomCode {
            base += "&sessionID=\(code)"
        }
        socketSerivce.connect(base)
    }
    
    // MARK: - Disconnect
    public func disconnect() {
        socketSerivce.disconnect()
        waitingRoom = nil
        gameModel = nil
        connectionStatus = false
        connectionError = nil
        flowError = nil
    }

    // MARK: - Handle data
    private func handle(_ data: Data) {
        let stringRepresentation = String(data: data, encoding: .utf8)
        self.logger.log(event: .socketRecieve(stringRepresentation))
        do {
            let sinData = try JSONDecoder().decode(MessageSinData.self, from: data)
            switch sinData.type {
            case .handshake:
                let id = try JSONDecoder().decode(Handshake.self, from: data)
                self.clientID = id.id
                connectionStatus = true
            case .waiting_room:
                try self.handleWaitingRoom(data)
            case .game_model:
                try self.handleGameModel(data)
            case .kickedPlayer:
                try self.handleKick(data)
            case .error:
                try self.handleErrorData(data)
            }
        } catch {
            
        }
    }

     private func handleErrorData(_ data: Data) throws {
         let errorMessage: ErrorMessage
         do {
             errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
             self.flowError = errorMessage
             self.flowError = nil
         }
         self.logger.log(event: .userFlowError(description: errorMessage.message))
     }

    private func handleError(_ error: Error) {
        var desciption: String?
        if let data = self.socketSerivce.socket?.closeReason {
            desciption = String(data: data, encoding: .utf8)
            self.connectionError = desciption
            self.connectionError = nil
        }
        self.logger.log(event: .socketRecieveError(error: error, desciption: desciption))
    }
    
    // MARK: - Post
    public func sendGamePref(_ creatorsPrefs: GamePreferences) {
        guard let catastropheId = creatorsPrefs.catastrophe?.id,
           let shelterId = creatorsPrefs.shelter?.id,
           let difficultyId = creatorsPrefs.difficulty?.rate
        else { return }
        
        let gamePref = GamePreferencesMessage(
            votingTime: creatorsPrefs.votingTime,
            catastropheId: catastropheId,
            gameConditions: [],
            shelterId: shelterId,
            difficultyId: difficultyId
        )
        // костыль ебаный
        let correctString = workAround(model: gamePref)
        do {
            self.socketSerivce.socket?.send(.string(correctString)) { (error) in
                if let networkError = error {
                    self.logger.log(event: .socketSendGamePrefFailed(gamePrefs: correctString, error: networkError))
                    print(networkError.localizedDescription)
                } else {
                    self.logger.log(event: .socketSendGamePrefSucceeded(gamePrefs: correctString))
                }
            }
        }
    }

    public func sendVote(forPlayer: String) {
        guard let clientID = clientID else {
            return
        }
        let message = VoteChoiceMessage(player: forPlayer, votedFor: clientID)
        let data = message.jsonString
        self.socketSerivce.socket?.send(.string(data)) { (error) in
            if let error = error {
                self.logger.log(event: .sendVoteChoiceFailed(data: data, error: error))
            } else {
                self.logger.log(event: .sendVoteChoiceSucceded(data: data))
            }
        }
    }
    
    public func startGame() {
        self.socketSerivce.socket?.send(.string("game")) { (error) in
            if let gameStartError = error {
                self.logger.log(event: .gameStartFailed(error: gameStartError))
                print(gameStartError.localizedDescription)
            } else {
                self.logger.log(event: .requestToStartGameSend())
            }
        }
    }

    public func sendChosenAttribute(attribute: AttributeChoiceMessage) {
        let data = attribute.jsonString
        self.socketSerivce.socket?.send(.string(data)) { (error) in
            if let attributeError = error {
                self.logger.log(event: .attributeChoiceFailed(attriute: data, error: attributeError))
                print(attributeError.localizedDescription)
            } else {
                self.logger.log(event: .attributeChoiceSucceeded(attriute: data))
            }
        }
    }
    
    // MARK: - Model setters
    private func handleGameModel(_ data: Data) throws {
        let gameModelMessage = try JSONDecoder().decode(GameMessage.self, from: data)
        guard let clientID = clientID else {
            return
        }

        let gameModel = Game(from: gameModelMessage, clientID: clientID)
        self.gameModel = gameModel
    }
    
    private func handleWaitingRoom(_ data: Data) throws {
        var roomModel = WaitingRoomMessage()
        do {
            roomModel = try JSONDecoder().decode(WaitingRoomMessage.self, from: data)
            self.logger.log(event: .waitingRoomDecodedSuccessfully(data: data.debugDescription))
        } catch let error {
            self.logger.log(event: .waitingRoomFailedToDecode(data: data.debugDescription, error: error))

        }
        var isCreator: Bool = false
        let players: [User] = roomModel.players.enumerated().map { (index, element) in
            if(element.id == self.clientID && element.isCreator) {
                isCreator = true
            }
            return User(orderNumber: index + 1, username: element.username, isCreator: element.isCreator)
        }
        let waitRoom = WaitingRoom(
            isCreator: isCreator,
            players: players,
            roomCode: roomModel.roomCode
        )
        self.waitingRoom = waitRoom
    }

    private func handleKick(_ data: Data) throws {
        do {
            let kickedPlayer = try JSONDecoder().decode(PlayerKicked.self, from: data)
            self.kickedPlayer = kickedPlayer
            self.logger.log(event: .kickPlayerRecieved(data: data.debugDescription))
        } catch let error {
            self.logger.log(event: .failedToDecodeKickedPlayer(data: data.debugDescription, error: error))
        }
    }
}

extension WebSocketController {
    private func workAround(model: GamePreferencesMessage) -> String {
        let keyValuePairs = [
            ("votingTime", model.votingTime),
            ("catastropheId", model.catastropheId),
            ("gameConditions", []),
            ("shelterId", model.shelterId),
            ("difficultyId", model.difficultyId)
        ] as [(String, Any)]
        
        let dict = Dictionary(uniqueKeysWithValues: keyValuePairs)
        let orderedKeys = keyValuePairs.map { $0.0 }
        
        var result = "{"
        for key in orderedKeys {
            let value = dict[key]!
            result += ("\"\(key)\": \(value),")
        }
        _ = result.popLast()
        result += "}"
        
        return result
    }
}

// MARK: - WebSocketServiceDelegate
extension WebSocketController: WebSocketServiceDelegate {
    func receivedData(data: Result<Data, Error>) {
        switch data {
        case .failure(let error):
            self.handleError(error)
        case .success(let data):
            self.handle(data)
        }
    }
}
