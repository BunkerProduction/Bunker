//
//  WebSocketService.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

protocol WebSocketServiceDelegate {
    func receivedData(data: Result<Data, Error>)
}

final class WebSocketService {
    private let logger = SHLogger.shared
    private let session: URLSession

    public var socket: URLSessionWebSocketTask?

    public var delegate: WebSocketServiceDelegate?

    // MARK: - Init
    init() {
        session = URLSession(configuration: .default)
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

    // MARK: - Listen
    private func listen() {
        self.socket?.receive { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.logger.log(event: .socketRecieve())
            switch result {
            case .failure(let error):
                self?.delegate?.receivedData(data: .failure(error))
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.delegate?.receivedData(data: .success(data))
                case .string(var str):
                    // temperary bug
                    if(str[str.startIndex] == "[") {
                        str.remove(at: str.startIndex)
                        str.remove(at: str.index(before: str.endIndex))
                    }
                    guard let data = str.data(using: .utf8) else { return }
                    self?.delegate?.receivedData(data: .success(data))
                default:
                    break
                }
            }
            sSelf.listen()
        }
    }

    // MARK: - Public
    public func connect(_ endPoint: String) {
        var request = URLRequest(url: URL(string: endPoint)!)
        request.addValue(UserSettings.applicationVersion, forHTTPHeaderField: "version_client")
        socket = session.webSocketTask(with: request)
        self.listen()
        self.socket?.resume()
        self.schedulePing()
    }

    // MARK: - Disconnect
    public func disconnect() {
        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil
    }
}
