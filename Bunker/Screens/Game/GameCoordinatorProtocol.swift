//
//  GameControllerProtocol.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.07.2022.
//

import UIKit

protocol GameCoordinator: AnyObject {
    func exitGame()
    func presentViewController(_ vc: UIViewController)
}
