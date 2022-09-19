//
//  DeepLink.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 24.08.2022.
//

import Foundation

enum DeepLink {
    case join(code: String)
}

enum DeepLinkDTO: String {
    case join
}

//?code=135345
