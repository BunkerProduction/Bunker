//
//  ThreatsProtocols.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.07.2022.
//

import UIKit

protocol ThreatsScreen: UIViewController {
    init(_ coordinator: GameCoordinator)
}

protocol ThreatsLogic {
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator)

    func exitGame()
}
