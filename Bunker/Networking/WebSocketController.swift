//
//  WebSocketController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 15.05.2022.
//

import Foundation
import UIKit

class WebSocketController {
    enum Endpoint {
        static let game = "ws://ktor-bunker.herokuapp.com/game"
        static let create = "ws://ktor-bunker.herokuapp.com/creategame"
        static let connect = ""
    }
    private let session: URLSession
    private var socket: URLSessionWebSocketTask!
    public static var shared = WebSocketController()
    
    init() {
        self.session = URLSession(configuration: .default)
        self.connect()
    }
    
    private func connect() {
        self.socket = session.webSocketTask(with: URL(string: Endpoint.game)!)
        self.listen()
        self.socket.resume()
        schedulePing()
    }
    
    private func schedulePing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.ping()
        }
    }
    
    private func ping() {
        socket.sendPing { (error) in
            if let error = error {
                print("Ping failed: \(error)")
            }
            self.schedulePing()
        }
    }
    
    private func listen() {
        self.socket.receive { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
                
                return
            case .success(let message):
                print(message)
            }
            self.listen()
        }
    }
    
    public func sendGamePref() {
        let gamePref = GamePreferences()
        
        do {
            let data = try JSONEncoder().encode(gamePref)
            self.socket.send(.data(data)) { (error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
        } catch {
            print(error)
        }
    }
}
