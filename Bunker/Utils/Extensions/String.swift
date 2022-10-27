//
//  String.swift
//  Bunker
//
//  Created by Danila Kokin on 26.10.2022.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
