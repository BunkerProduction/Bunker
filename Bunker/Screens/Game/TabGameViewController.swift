//
//  TabGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class TabGameViewController: UIViewController {
    private var viewControllers = [UIViewController]()
    private var settings = UserSettings.shared
    private var tabView = BunkerTabBar()
    private var selectedIndex = 0
    private var previousIndex = 0
    
    static private let firstVC = ThreatsViewController()
    static private let secondVC = MainGameViewController()
    static private let thirdVC = PlayerViewController()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(TabGameViewController.firstVC)
        viewControllers.append(TabGameViewController.secondVC)
        viewControllers.append(TabGameViewController.thirdVC)
        
        setupView()
        updateUI()
        
        tabBarChosen(tabView)
    }
    
    // MARK: - UI setup
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(tabView)
        
        tabView.pin(to: view, [.left: 24, .right: 24])
        tabView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
        tabView.addTarget(self, action: #selector(tabBarChosen(_:)), for: .valueChanged)
    }
    
    // MARK: - UpdateUI
    private func updateUI() {
        let theme = settings.appearance
        tabView.setTheme(theme)
        
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }
    
    // MARK: - Interactions
    @objc
    private func tabBarChosen(_ sender: BunkerTabBar) {
        previousIndex = selectedIndex
        selectedIndex = sender.chosenTab
        
        let previosVC = viewControllers[previousIndex]
        
        previosVC.willMove(toParent: nil)
        previosVC.view.removeFromSuperview()
        previosVC.removeFromParent()
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = self.view.frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
}
