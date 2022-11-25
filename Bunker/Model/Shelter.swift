//
//  Shelter.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct Shelter {
    let id: Int
    let icon: String
    let name: String
    let description: String
    var shelterConditions: [ShelterCondition] = []

    init(id: Int, conditions: [ShelterCondition] = []) {
        let shelter = Self.getAll()[id]
        self.id = shelter.id
        self.icon = shelter.icon
        self.name = shelter.name
        self.description = shelter.description
        shelterConditions = conditions
    }
    
    public static func random() -> Shelter {
        let random = Int.random(in: 0...13)
        return Shelter(id: random)
    }

    public static func getAll() -> [Shelter] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "shelter_eng") {
            do {
                let allShelters = try decoder.decode([Shelter].self, from: data)
                return allShelters
            } catch {
                print("Failed to decode")
            }
        }
        return []
    }
}

extension Shelter: Hashable { }

extension Shelter: Codable {
    enum ShelterError: Error {
        case failedToDecodeShelter
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              let id = try? container.decodeIfPresent(Int.self, forKey: .id),
              let icon = try? container.decodeIfPresent(String.self, forKey: .icon),
              let name = try? container.decodeIfPresent(String.self, forKey: .name),
              let description = try? container.decodeIfPresent(String.self, forKey: .description)
        else {
            throw ShelterError.failedToDecodeShelter
        }
        self.id = id
        self.icon = icon
        self.name = name
        self.description = description
    }
}

// MARK: - ShelterCondition
struct ShelterCondition {
    let id: Int
    let name: String
    let description: String
    var isExposed: Bool = false

    init(id: Int, isExposed: Bool = false) {
        let condition = Self.getAll()[id]
        self.id = condition.id
        self.name = condition.name
        self.description = condition.description
        self.isExposed = isExposed
    }

    public static func getAll() -> [ShelterCondition] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "condition_eng") {
            do {
                let allConditions = try decoder.decode([ShelterCondition].self, from: data)
                return allConditions
            } catch(let error) {
                print(error)
            }
        }
        return []
    }
}

extension ShelterCondition: Hashable { }

extension ShelterCondition: Codable {
    enum ConditionError: Error {
        case failedToDecodeConditions
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              let id = try? container.decodeIfPresent(Int.self, forKey: .id),
              let name = try? container.decodeIfPresent(String.self, forKey: .name),
              let description = try? container.decodeIfPresent(String.self, forKey: .description)
        else {
            throw ConditionError.failedToDecodeConditions
        }
        self.id = id
        self.name = name
        self.description = description
        self.isExposed = false
    }
}
