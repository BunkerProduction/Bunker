//
//  SceneDelegate.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: MainWindow?
    let rootViewController = WelcomeController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = MainWindow(windowScene: windowScene)
        let navControllerWelcome = BaseNavigationController(rootViewController: rootViewController)
        window.rootViewController = navControllerWelcome
        self.window = window

        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(openURLContexts: connectionOptions.urlContexts)
        }

        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handleDeepLink(openURLContexts: URLContexts)
    }

    private func handleDeepLink(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url,
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host,
              let deeplink = DeepLinkDTO(rawValue: host)
        else {
            return
        }

        switch deeplink {
        case .join:
            let code = components.queryItems?.first(where: { $0.name == "code"})?.value
            let rootViewController = WelcomeController()
            let link = DeepLink.join(code: code ?? "123333")
            rootViewController.handleDeepLink(link: link)
            let navControllerWelcome = BaseNavigationController(rootViewController: rootViewController)
            window?.rootViewController = navControllerWelcome
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        ProductManager.shared.fetchProducts()
        window?.debugView.frame = CGRect(x: 10, y: 200, width: 50, height: 50)
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

