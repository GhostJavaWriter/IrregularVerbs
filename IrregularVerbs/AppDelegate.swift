//
//  AppDelegate.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = ViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        UINavigationBar.appearance().tintColor = Colors.groupOne
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

