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

    func localize(lan: Language?) -> String {
        if let language = lan {
            if let path = Bundle.main.path(
                forResource: language.rawValue,
                ofType: "lproj"
            ) {
                if let bundle = Bundle(path: path) {
                    return NSLocalizedString(
                        self,
                        tableName: nil,
                        bundle: bundle,
                        value: "",
                        comment: "")
                }
            }
        }
        return ""
    }
}


