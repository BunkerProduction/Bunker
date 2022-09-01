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
        case base = "wss://ktor-bunker.herokuapp.com/game?username="
    }

    private let logger = SHLogger()
    public static var shared = WebSocketController()
    private let session: URLSession
    private var socket: URLSessionWebSocketTask?
    private var clientID: String?
    
    @Published var waitingRoom: WaitingRoom?
    @Published var connectionStatus: Bool = false
    @Published var gameModel: Game?
    @Published var connectionError: String?
    
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
    
    // MARK: - Init
    init() {
        session = URLSession(configuration: .default)
    }
    
    // MARK: - Connetion
    private func connect(_ endPoint: String) {
        socket = session.webSocketTask(with: URL(string: endPoint)!)
        self.listen()
        self.socket?.resume()
        self.schedulePing()
    }
    
    public func connectToGame(username: String, roomCode: String? , isCreator: Bool) {
        var base = Endpoint.base.rawValue
        base += username
        base += "&isCreator=\(isCreator)"
        if let code = roomCode {
            base += "&sessionID=\(code)"
        }
        connect(base)
    }
    
    // MARK: - Disconnect
    public func disconnect() {
        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil
        waitingRoom = nil
        gameModel = nil
        connectionStatus = false
        connectionError = nil
    }
    
    // MARK: - Ping-Pong
    private func schedulePing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.ping()
        }
    }
    
    private func ping() {
        socket?.sendPing { [self] (error) in
            if let error = error {
                logger.log(event: .pingError(error: error))
                if let failReason = socket?.closeReason {
                    print(String(decoding: failReason, as: UTF8.self))
                }
            } else {
                logger.log(event: .pingSucceeded())
            }
            self.schedulePing()
        }
    }

    // MARK: - Handle data
    private func handle(_ data: Data) {
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
            }
        } catch {
            
        }
    }

    private func handleError(_ error: Error) {
        var desciption: String?
        if let data = self.socket?.closeReason {
            desciption = String(data: data, encoding: .utf8)
            self.connectionError = desciption
            self.connectionError = nil
        }
        self.logger.log(event: .socketRecieveError(error: error, desciption: desciption))
    }
    
    // MARK: - Listen
    private func listen() {
        self.socket?.receive { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.logger.log(event: .socketRecieve())
            switch result {
            case .failure(let error):
                sSelf.handleError(error)
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    sSelf.handle(data)
                case .string(var str):
                    // temperary bug
                    if(str[str.startIndex] == "[") {
                        str.remove(at: str.startIndex)
                        str.remove(at: str.index(before: str.endIndex))
                    }
                    guard let data = str.data(using: .utf8) else { return }
                    sSelf.handle(data)
                default:
                    break
                }
            }
            sSelf.listen()
        }
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
            let data = correctString.data(using: .utf8)!
            self.socket?.send(.string(correctString)) { (error) in
                if let networkError = error {
                    self.logger.log(event: .socketSendGamePrefFailed(gamePrefs: correctString, error: networkError))
                    print(networkError.localizedDescription)
                } else {
                    self.logger.log(event: .socketSendGamePrefSucceeded(gamePrefs: correctString))
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func startGame() {
        self.socket?.send(.string("game")) { (error) in
            if let gameStartError = error {
                self.logger.log(event: .gameStartFailed(error: gameStartError))
                print(gameStartError.localizedDescription)
            } else {
                self.logger.log(event: .gameStartSucceeded())
            }
        }
    }

    public func sendChosenAttribute(attribute: AttributeChoiceMessage) {
        let data = attribute.jsonString
        self.socket?.send(.string(data)) { (error) in
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
        guard let myPlayerMessage = gameModelMessage.players.first(where: { $0.id == self.clientID })
        else {
            return
        }
        let gameModel = Game(
            gamePreferences: GamePreferences(message: gameModelMessage.preferences),
            players: gameModelMessage.players.map {
                Player(
                    UID: $0.id,
                    username: $0.username,
                    attributes: $0.attributes.enumerated().map { Attribute(identifier: $1.id, position: $0, isExposed: $1.isExposed) }
                )
            },
            turn: gameModelMessage.turn,
            round: 0,
            gameState: .normal,
            myPlayer: Player(
                UID: myPlayerMessage.id,
                username: myPlayerMessage.username,
                attributes: myPlayerMessage.attributes.enumerated().map { Attribute(identifier: $1.id, position: $0, isExposed: $1.isExposed) }
            )
        )
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
