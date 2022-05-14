//
//  Catastrophe.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct Catastrophe {
    let id: Int
    let name: String
    let shortDescription: String
    let icon: String
    let fullDesciption: String
    
    public static func getAll() -> [Catastrophe] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "catastrophe") {
            do {
                let allCatastrophes = try decoder.decode([Catastrophe].self, from: data)
                return allCatastrophes
            } catch {
                print("Failed to decode")
            }
        }
        return []
    }
}

extension Catastrophe: Codable { }

extension Catastrophe: Equatable {
    static func == (lhs: Catastrophe, rhs: Catastrophe) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
}
