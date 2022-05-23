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
        socket?.sendPing { (error) in
            if let error = error {
                print("Ping failed: \(error)")
            } else {
                print("Ping is fine")
            }
            self.schedulePing()
        }
    }
    
    // MARK: - Get
    private func handle(_ data: Data) {
        // generic.неБудет
        let str = String(decoding: data, as: UTF8.self)
        print(str)
        if(str == "You are connected!") {
            connectionStatus = true
            return
        }
        do {
            let roomModel = try JSONDecoder().decode(WaitingRoomMessage.self, from: data)
            let waitRoom = WaitingRoom(
                players: roomModel.players.enumerated().map { (index, element) in
                    User(orderNumber: index + 1, username: element.username, isCreator: element.isCreator)
                    
                },
                roomCode: roomModel.roomCode
            )
            self.waitingRoom = waitRoom
        } catch {
            do {
                let gameModelMessage = try JSONDecoder().decode([GameMessage].self, from: data)
                print(gameModelMessage)
                let gameModel = Game(gamePreferences: GamePreferences(), players: [], turn: 0, round: 0, gameState: .normal)
                self.gameModel = gameModel
            } catch {
                print(error)
            }
            
        }
    }
    
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
                case .string(let str):
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
        result.popLast()
        result += "}"
        
        return result
    }
}
