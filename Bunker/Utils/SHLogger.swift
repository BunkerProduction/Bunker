//
//  SHLogger.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.08.2022.
//

import UIKit

final class SHLogger {
    func log(event: Event) {
        print(event.debugString)
    }
}

public enum Event {
    case info(description: String)
    case error(description: String, error: Error?)

    var debugString: String {
        var string = "SHLogger: "
        switch self {
        case .info(let description):
            string += description
        case .error(let description, let error):
            string += description + "Thrown error: \(error)"
        }
        return string
    }
}


extension Event {
    static func pingError(error: Error?) -> Event {
        return .error(description: "ping failed", error: error)
    }

    static func pingSucceded() -> Event {
        return .info(description: "ping succesfull")
    }

    static func socketRecieve() -> Event {
        return .info(description: "Socket recieve data")
    }

    static func socketSendGamePrefSucceded(gamePrefs: String) -> Event {
        return .info(description: "socketSendGamePrefs Succeeded \(gamePrefs)")
    }

    static func socketSendGamePrefFailed(gamePrefs: String, error: Error?) -> Event {
        return .error(description: "socketSendGamePrefs, gameprefs: \(gamePrefs)", error: error)
    }
}
