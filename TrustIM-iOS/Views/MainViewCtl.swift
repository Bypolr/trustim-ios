//
// Created by towry on 02/03/2017.
// Copyright (c) 2017 towry. All rights reserved.
//

import UIKit

class MainViewCtl: BaseViewCtl {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginVc = LoginViewCtl()
        self.navigationController?.pushViewController(loginVc, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
