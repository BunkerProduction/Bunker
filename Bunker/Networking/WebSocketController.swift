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
    
    public static var shared = WebSocketController()
    private let session: URLSession
    private var socket: URLSessionWebSocketTask?
    private var clientID: String?
    
    @Published var waitingRoom: WaitingRoom?
    @Published var connectionStatus: Bool = false
    @Published var gameModel: Game?
    
    var waitingRoomRecieved: AnyPublisher<WaitingRoom?, Never> {
        return $waitingRoom.eraseToAnyPublisher()
    }
    var connectionStatusSub: AnyPublisher<Bool, Never> {
        return $connectionStatus.eraseToAnyPublisher()
    }
    var gameModelRecieved: AnyPublisher<Game?, Never> {
        return $gameModel.eraseToAnyPublisher()
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
        socket?.cancel(with: .goingAway, reason: nil)
        waitingRoom = nil
        connectionStatus = false
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
                print("Ping failed: \(error)")
                if let failReason = socket?.closeReason {
                    print(String(decoding: failReason, as: UTF8.self))
                }
            } else {
                print("Ping is fine")
            }
            self.schedulePing()
        }
    }
    
    // MARK: - Handle data
    private func handle(_ data: Data) {
        print(data)
        do {
            let sinData = try JSONDecoder().decode(MessageSinData.self, from: data)
            print(sinData)
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
    
    // MARK: - Listen
    private func listen() {
        self.socket?.receive { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
                
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(var str):
                    print(str)
                    // temperary bug
                    if(str[str.startIndex] == "[") {
                        str.remove(at: str.startIndex)
                        str.remove(at: str.index(before: str.endIndex))
                    }
                    guard let data = str.data(using: .utf8) else { return }
                    self.handle(data)
                default:
                    break
                }
            }
            self.listen()
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
            shelterId: shelterId,
            difficultyId: difficultyId
        )
        // костыль ебаный
        let correctString = workAround(model: gamePref)
        do {
            let data = correctString.data(using: .utf8)!
            print(String(data: data, encoding: .utf8)!)
            self.socket?.send(.string(correctString)) { (error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func startGame() {
        self.socket?.send(.string("game")) { (error) in
            if error != nil {
                print(error.debugDescription)
            }
        }
    }

    public func sendChosenAttribute(attribute: AttributeChoiceMessage) {
        self.socket?.send(.data(attribute.json)) { error in
            if error != nil {
                print(error.debugDescription)
            } else {
                print("send successfully")
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
            gamePreferences: GamePreferences(
                catastropheId: gameModelMessage.preferences.catastropheId
            ),
            players: gameModelMessage.players.map {
                Player(
                    UID: $0.id,
                    username: $0.username,
                    attributes: $0.attributes.enumerated().map { Attribute(identifier: $1.id, position: $0, isExposed: $1.isExposed) }
                )
            },
            turn: 0,
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
        let roomModel = try JSONDecoder().decode(WaitingRoomMessage.self, from: data)
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
            ("shelterId", model.shelterId),
            ("difficultyId", model.difficultyId)
        ]
        
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
