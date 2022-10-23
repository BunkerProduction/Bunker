//
//  InstructionPageModel.swift
//  Bunker
//
//  Created by Danila Kokin on 18.09.2022.
//

import Foundation

struct InstructionBlock: Codable {
    let subtitle: String?
    let text: [String]
}

struct InstructionSection: Codable {
    let title: String?
    let blocks: [InstructionBlock]
}

struct InstructionScreen: Codable {
    let headline: String?
    let sections: [InstructionSection]
}
