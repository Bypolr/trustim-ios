//
//  AppDelegate.swift
//  TrustIM-iOS
//
//  Created by towry on 02/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainViewCtl()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
