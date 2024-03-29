//
//  Catastrophe.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct Catastrophe: Hashable {
    let id: Int
    let name: String
    let shortDescription: String
    let icon: String
    let fullDesciption: String
    
    public static func getAll() -> [Catastrophe] {
        let decoder = JSONDecoder()
        if let data = JsonManager.shared.readLocalFile(forName: "catastrophe_eng") {
            do {
                let allCatastrophes = try decoder.decode([Catastrophe].self, from: data)
                return allCatastrophes
            } catch {
                print("Failed to decode")
            }
        }
        return []
    }

    public static func random() -> Catastrophe {
        let all = Self.getAll()
        let pos = Int.random(in: 0...all.count-1)
        return all[pos]
    }
}

extension Catastrophe: Codable { }

extension Catastrophe: Equatable {
    static func == (lhs: Catastrophe, rhs: Catastrophe) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
}
