import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: Builder.createMainViewController())
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}

