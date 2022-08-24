//
//  GamePreferences.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct GamePreferences {
    var votingTime: Int = 0
    var catastrophe: Catastrophe?
    var shelter: Shelter?
    var conditions: [ShelterCondition]?
    var difficulty: GameDifficulty?

    init() {
        catastrophe = Catastrophe.getAll()[0]
        shelter = Shelter.random()
        difficulty = GameDifficulty(rate: 1)
    }

    init(catastropheId: Int, conditions: [ShelterCondition]?) {
        catastrophe = Catastrophe.getAll()[catastropheId]
        shelter = Shelter.random()
        difficulty = GameDifficulty(rate: 1)
        self.conditions = conditions
    }
}

extension GamePreferences: Codable { }

struct ShelterCondition {
    let id: Int
    let name: String
    let description: String
    var isExposed: Bool = false

    init(id: Int, isExposed: Bool = false) {
        let condition = Self.getAll().first { $0.id == id }

        self.id = condition!.id
        self.name = condition!.name
        self.description = condition!.description
        self.isExposed = isExposed
    }

    public static func getAll() -> [ShelterCondition] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "condition") {
            do {
                let allConditions = try decoder.decode([ShelterCondition].self, from: data)
                return allConditions
            } catch (let error)  {
                print("Failed to decode: \(error)")
            }
        }
        print("💬: No conditions")
        return []
    }
}

extension ShelterCondition: Codable {}

// MARK: - Difficulty
struct GameDifficulty {
    let rate: Int
}

extension GameDifficulty: Codable { }
