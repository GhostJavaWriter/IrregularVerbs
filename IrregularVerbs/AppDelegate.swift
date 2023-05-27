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

//        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSerifDisplay-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)]
//        UINavigationBar.appearance().standardAppearance = appearance
//
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "NotoSerifDisplay-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)]
//        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

