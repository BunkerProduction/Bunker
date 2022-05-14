//
//  Shelter.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct Shelter: Codable {
    let id: Int
    let icon: String
    let name: String
    let description: String
    let shelterConditions: [String] = []
    
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
}
