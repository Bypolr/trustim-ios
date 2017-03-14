//
// Created by towry on 02/03/2017.
// Copyright (c) 2017 towry. All rights reserved.
//

import UIKit

class MainViewCtl: BaseViewCtl, TINavigationDelegate {
    private let loggedin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TrustIM"

        if (loggedin) {
            self.loadTabController()
        } else {
            let loginVc = LoginViewCtl()
            loginVc.delegate = self
            self.navigationController?.pushViewController(loginVc, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func loadTabController() {
        let chatListVc: UIKit.UIViewController = ChatListViewCtl()
        let chatListNav = UINavigationController(rootViewController: chatListVc)

        let tabs: UITabBarController = UITabBarController()
        tabs.viewControllers = [chatListNav]

        // replace the root view ctl
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = tabs
        window?.makeKeyAndVisible()
    }
}

// MARK - delegates
extension MainViewCtl {
    func loginSuccess() {
        self.loadTabController()
    }
}