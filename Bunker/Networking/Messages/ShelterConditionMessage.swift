//
//  ShelterConditionMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

struct ShelterConditionsMessage {
    let Condition: Int
    let isExposed: Bool
}

extension ShelterConditionsMessage: Codable { }
