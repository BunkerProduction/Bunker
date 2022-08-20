//
//  TabGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class TabGameViewController: UIViewController, GameCoordinator {
    private var viewControllers = [UIViewController]()
    private var settings = UserSettings.shared
    private var tabView = BunkerTabBar()
    private let networkService = WebSocketController.shared
    private var selectedIndex = 0
    private var previousIndex = 0

    private lazy var firstVC = ThreatsViewController(self)
    private lazy var secondVC = MainGameViewController(self)
    private lazy var thirdVC = PlayerViewController(self)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllers()
        setupView()
        updateUI()

        tabBarChosen(tabView)
    }

    private func setupControllers() {
        viewControllers.append(self.WrapperControllerInNav(firstVC))
        viewControllers.append(self.WrapperControllerInNav(secondVC))
        viewControllers.append(self.WrapperControllerInNav(thirdVC))
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

    public func exitGame() {
        networkService.disconnect()
        self.navigationController?.popToRootViewController(animated: true)
    }

    public func presentViewController(_ vc: UIViewController) {
        self.navigationController?.present(vc, animated: true)
    }
}

extension UIViewController {
    func WrapperControllerInNav(_ vc: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: vc)
    }
}
