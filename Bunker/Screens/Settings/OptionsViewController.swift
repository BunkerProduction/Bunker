//
//  OptionsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

final class OptionsViewController: UIViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
    }
    
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Настройки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - Interactions
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension OptionsViewController: UIGestureRecognizerDelegate { }
