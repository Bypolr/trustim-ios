//
//  MainApp.swift
//  TrustIM-iOS
//
//  Created by towry on 04/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

@UIApplicationMain
class MainApp: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navCtl: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainViewCtl = MainViewCtl()
        navCtl = UINavigationController(rootViewController: mainViewCtl)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navCtl!
        window?.makeKeyAndVisible()
        
        globalCustomize()
        
        return true
    }
    
    func globalCustomize() {
        window?.backgroundColor = Refs.Color.tintColor
        UIView.appearance().tintColor = Refs.Color.tintColor
        // - navigationbar
        UINavigationBar.appearance().barTintColor = Refs.Color.tintColor
        // hide the bar border
        // UINavigationBar.appearance().clipsToBounds = true
        navCtl?.navigationBar.isTranslucent = false
    }
}
