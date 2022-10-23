//
//  SHLogger.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.08.2022.
//

import UIKit

protocol SHLoggerDelegate {
    func newLogs()
}

final class SHLogger {
    public var sessionLogs: [Event] = []

    public var delegate: SHLoggerDelegate?
    public static let shared = SHLogger()


    func log(event: Event) {
        self.sessionLogs.append(event)
        print(event.debugString)

        delegate?.newLogs()
    }
}

public enum Event {
    case info(description: String, explicitDataToShow: String? = nil)
    case error(description: String, error: Error?)

    var debugString: String {
        var string = "SHLogger: "
        switch self {
        case .info(let description, _):
            string += description
        case .error(let description, let error):
            string += description + "Thrown error: \(String(describing: error))"
        }
        return string
    }
}


extension Event {
    static func pingError(error: Error?) -> Event {
        return .error(description: "🔴 ping failed", error: error)
    }

    static func pingSucceeded() -> Event {
        return .info(description: "🟢 ping succesfull")
    }

    static func socketRecieve(_ data: String? = nil) -> Event {
        return .info(description: "🟣 Socket recieve data", explicitDataToShow: data)
    }

    static func socketRecieveError(error: Error, desciption: String? ) -> Event {
        return .error(description: "🔻 recieve error \(String(describing: desciption))", error: error)
    }

    static func userFlowError(description: String?) -> Event {
        return .info(description: "🔻 recieve error \(String(describing: description))")
    }

    static func socketSendGamePrefSucceeded(gamePrefs: String) -> Event {
        return .info(description: "🔹 socketSendGamePrefs Succeeded \(gamePrefs)")
    }

    static func socketSendGamePrefFailed(gamePrefs: String, error: Error?) -> Event {
        return .error(description: "🔻 socketSendGamePrefs, gameprefs: \(gamePrefs)", error: error)
    }

    static func attributeChoiceSucceeded(attriute: String) -> Event {
        return .info(description: "🔹 send successfully \(attriute)")
    }

    static func attributeChoiceFailed(attriute: String, error: Error) -> Event {
        return .error(description: "🔻 attribute: \(attriute)", error: error)
    }

    static func requestToStartGameSend() -> Event {
        return .info(description: "🔹 request to start game sent")
    }

    static func gameStartSucceeded() -> Event {
        return .info(description: "🔹 Game started successfully")
    }

    static func gameStartFailed(error: Error?) -> Event {
        return .error(description: "🔻 Game start failed", error: error)
    }

    static func waitingRoomDecodedSuccessfully(data: String) -> Event {
        return .info(description: "🔸 Waiting room recieved data: \(data.debugDescription)")
    }

    static func waitingRoomFailedToDecode(data: String, error: Error) -> Event {
        return .error(description: "🔻 Waiting room failed", error: error)
    }

    static func sendVoteChoiceFailed(data: String, error: Error) -> Event {
        return .error(description: "🔻 Send Vote failed: \(data)", error: error)
    }

    static func sendVoteChoiceSucceded(data: String) -> Event {
        return .info(description: "🔹 Sent vote successfully: \(data)")
    }

    static func kickPlayerRecieved(data: String) -> Event {
        return .info(description: "🔹🔻🔹 Recieve kicked player successfully: \(data)")
    }

    static func failedToDecodeKickedPlayer(data: String, error: Error) -> Event {
        return .error(description: "🔻 Decode Kicked player failed: \(data)", error: error)
    }
}
