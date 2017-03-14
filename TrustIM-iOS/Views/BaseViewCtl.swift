//
//  BaseViewCtl.swift
//  TrustIM-iOS
//
//  Created by towry on 03/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

protocol TINavigationDelegate {
    func loginSuccess()
}

class BaseViewCtl: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Refs.Color.bgColor
    }
}
