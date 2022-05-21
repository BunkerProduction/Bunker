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
        case game = "wss://ktor-bunker.herokuapp.com/game?username=name&isCreator=true"
        case connectToGame = "wss://ktor-bunker.herokuapp.com//game?usename=name&isCreator=false&sessionID="
    }
    
    public static var shared = WebSocketController()
    private let session: URLSession
    private var socket: URLSessionWebSocketTask?
    @Published var waitingRoom: WaitingRoom?
    @Published var connectionStatus: Bool = false
    var waitingRoomRecieved: AnyPublisher<WaitingRoom?, Never> {
        return $waitingRoom.eraseToAnyPublisher()
    }
    var connectionStatusSub: AnyPublisher<Bool, Never> {
        return $connectionStatus.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init() {
        session = URLSession(configuration: .default)
        connect(Endpoint.game.rawValue)
    }
    
    public func connectToGame(id: String) {
        var base = Endpoint.connectToGame.rawValue
        base += id
        connect(base)
    }
    
    // MARK: - Connetion
    private func connect(_ endPoint: String) {
        socket = session.webSocketTask(with: URL(string: endPoint)!)
        self.listen()
        self.socket?.resume()
        self.schedulePing()
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
            let decodedShit = try JSONDecoder().decode([Player].self, from: data)
            let players: [User] = decodedShit.map {
                User(username: $0.username, isCreator: false)
            }
            let waitingRoom = WaitingRoom(users: players, roomCode: decodedShit[0].sessionID)
            self.waitingRoom = waitingRoom
        } catch {
            print(error)
        }
        // temp for test
        self.waitingRoom = WaitingRoom(
            users: [
                User(username: "someName", isCreator: true),
                User(username: "someName2", isCreator: false),
                User(username: "someName3", isCreator: false)
            ],
            roomCode: "196207"
        )
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
    public func sendGamePref() {
        let gamePref = GamePreferencesMessage(voitingTime: 1, catastropheId: 1, shelterId: 1, difficultyId: 1)
        // костыль ебаный
        let correctString = workAround(model: gamePref)
        do {
//            let encoder = JSONEncoder()
////            encoder.outputFormatting = [.sortedKeys]
//            let data = try encoder.encode(correctString)
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
    
    private func workAround(model: GamePreferencesMessage) -> String {
        let keyValuePairs = [
            ("voitingTime", model.voitingTime),
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



// костыльные структуры для обработки ответов бэка
struct Player: Codable {
    let username: String
    let sessionID: String
}
