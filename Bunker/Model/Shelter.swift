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
    var shelterConditions: [String] = []
    
    public static func getAll() -> [Shelter] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "shelter") {
            do {
                let allShelters = try decoder.decode([Shelter].self, from: data)
                return allShelters
            } catch {
                print("Failed to decode")
            }
        }
        return []
    }
    
    public static func random() -> Shelter {
//        let shelters = getAll()
//        return shelters[0]
        return Shelter(id: 1, icon: "s", name: "s", description: "s")
    }
}

extension Shelter: Codable { }
