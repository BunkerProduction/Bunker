//
//  MainGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class MainGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .red
    }
}
