//
//  Game.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import Foundation

enum GameState: String, Codable {
    case normal, voting, finished
}

enum GameModelError: String, Error {
    case failedToInitFromMessage
}

struct Game {
    let gamePreferences: GamePreferences
    let players: [Player]
    let turn: String
    let round: Int
    let gameState: GameState
    let myPlayer: Player
    var hasVoted: Bool = false
}

extension Game {
    init?(from message: GameMessage, clientID: String) {
        guard let myPlayerMessage = message.players.first(where: { $0.id == clientID }) else {
            return nil
        }

        gamePreferences = GamePreferences(message: message.preferences)

        players = message.players.map {
            var votesForPlayer: Double?
            if let votes = message.votes?[$0.id] {
                votesForPlayer = Double(votes) / Double(message.players.count)
            }
            return Player(
                UID: $0.id,
                username: $0.username,
                attributes: $0.attributes.enumerated().map {
                    Attribute(identifier: $1.id, position: $0, isExposed: $1.isExposed)
                },
                votesForHim: votesForPlayer ?? 0.0
            )
        }

        turn = message.turn
        round = message.round
        gameState = message.gameState
        myPlayer = Player(
            UID: myPlayerMessage.id,
            username: myPlayerMessage.username,
            attributes: myPlayerMessage.attributes.enumerated().map { Attribute(identifier: $1.id, position: $0, isExposed: $1.isExposed) },
            votesForHim: 0.0
        )
        hasVoted = message.set_of_voters?.contains(clientID) ?? false
    }
}
