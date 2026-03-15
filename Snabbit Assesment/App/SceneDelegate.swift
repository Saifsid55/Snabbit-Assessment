//
//  SceneDelegate.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let appContainer = AppDependencyContainer()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        Task { [weak self] in
            guard let self else { return }
            
            if Auth.auth().currentUser == nil {
                
                let loginVC = self.appContainer.makeLoginViewController()
                navigationController.setViewControllers([loginVC], animated: false)
                return
            }
            
            do {
                
                let repository = self.appContainer.makeQuestionnaireRepository()
                let hasAnswered = try await repository.hasSubmittedQuestionnaire()
                
                if hasAnswered {
                    
                    let breakVC = self.appContainer.makeBreakViewController()
                    navigationController.setViewControllers([breakVC], animated: false)
                    
                } else {
                    
                    let questionnaireVC = self.appContainer.makeQuestionnaireViewController()
                    navigationController.setViewControllers([questionnaireVC], animated: false)
                }
                
            } catch {
                
                let loginVC = self.appContainer.makeLoginViewController()
                navigationController.setViewControllers([loginVC], animated: false)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
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

