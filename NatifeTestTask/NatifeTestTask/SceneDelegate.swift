//
//  SceneDelegate.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let view = DefaultPostListAssembly().createPostsModule()
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
}

