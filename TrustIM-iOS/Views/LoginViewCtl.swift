//
//  LoginViewCtl.swift
//  TrustIM-iOS
//
//  Created by towry on 02/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewCtl: BaseViewCtl {
    
    var vm: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
        navigationItem.hidesBackButton = true
        title = "Login"
    
        setupView()
    }
    
    func setupView() {
        let loginFormView = UIView()
        view.addSubview(loginFormView)
        
        let emailInput = UITextField()
        emailInput.placeholder = "Email address"
        emailInput.backgroundColor = UIColor.white
        emailInput.borderStyle = .roundedRect
        loginFormView.addSubview(emailInput)
        
        let passwordInput = UITextField()
        passwordInput.placeholder = "Password"
        passwordInput.backgroundColor = UIColor.white
        passwordInput.borderStyle = .roundedRect
        loginFormView.addSubview(passwordInput)
        
        emailInput.snp.makeConstraints { (make) in
            make.top.equalTo(loginFormView.snp.top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        passwordInput.snp.makeConstraints { (make) in
            make.top.equalTo(emailInput.snp.bottom).offset(20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        loginFormView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(140)
        }
    }
}
