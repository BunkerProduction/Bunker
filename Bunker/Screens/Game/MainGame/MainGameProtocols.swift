//
//  MainGameProtocols.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.08.2022.
//

import UIKit

protocol MainGameScreen: AnyObject {
    func setupHeaderView(model: GameHeaderView.ViewModel)
}
