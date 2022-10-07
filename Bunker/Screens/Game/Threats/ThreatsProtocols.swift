//
//  ThreatsProtocols.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.07.2022.
//

import UIKit

enum ThreatsSection: String {
    case conditions
    case shelter
    case catastrophe
    case exit
}

protocol ThreatsScreen: UIViewController {
    init(_ coordinator: GameCoordinator)
}

protocol ThreatsLogic {
    var sections: [ThreatsSection] { get }
    
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator)

    func exitGame()
}
