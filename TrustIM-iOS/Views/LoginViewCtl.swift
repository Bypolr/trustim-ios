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
    var formView: UIView?
    var keyboardNeedLayout = true
    var formBottomConstraint: Constraint? = nil
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = Refs.Color.primaryColor
        btn.layer.cornerRadius = Refs.Shape.cornerRadius
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
        navigationItem.hidesBackButton = true
        title = "Login"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
    
    func setupView() {
        let loginFormView = UIView()
        view.addSubview(loginFormView)
        
        let emailInput = TITextField()
        emailInput.placeholder = "Email address"
        emailInput.backgroundColor = UIColor.white
        emailInput.keyboardType = .emailAddress
        emailInput.autocapitalizationType = .none
        emailInput.tag = 1
        emailInput.roundCorners(corners: [.topLeft, .topRight], radius: Refs.Shape.cornerRadius)
        
        emailInput.delegate = self
        loginFormView.addSubview(emailInput)
        
        let passwordInput = TITextField()
        passwordInput.placeholder = "Password"
        passwordInput.backgroundColor = UIColor.white
        passwordInput.isSecureTextEntry = true
        passwordInput.tag = 2
        passwordInput.delegate = self
        passwordInput.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Refs.Shape.cornerRadius)
        loginFormView.addSubview(passwordInput)
        
        let font = UIFont(name: (emailInput.font?.fontName)!, size: 13.0)
        emailInput.font = font
        passwordInput.font = font
        
        // Login button
        loginFormView.addSubview(loginBtn)
        
        loginFormView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            self.formBottomConstraint = make.centerY.equalTo(view).constraint
            make.width.equalTo(250)
            make.height.equalTo(130)
        }
        
        emailInput.snp.makeConstraints { (make) in
            make.top.equalTo(loginFormView.snp.top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        passwordInput.snp.makeConstraints { (make) in
            make.top.equalTo(emailInput.snp.bottom).offset(-1)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInput.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        // loginFormView.backgroundColor = UIColor.cyan
        self.formView = loginFormView
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
}


extension LoginViewCtl {
    func keyboardWasShown(aNotification: Notification) {
        var kbRect = (aNotification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        kbRect = self.view.convert(kbRect!, from: UIApplication.shared.keyWindow!)
        
        let v = self.formView!
        
        if (v.frame.origin.y + v.bounds.height) > (kbRect?.origin.y)! {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                let offset = (kbRect?.origin.y)! - (v.frame.origin.y + v.bounds.height)
                self.formBottomConstraint?.update(offset: offset)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func keyboardWillBeHidden(aNotification: Notification) {
        self.formBottomConstraint?.update(offset: 0)
        self.view.layoutIfNeeded()
    }
}

extension LoginViewCtl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        // we don want it to insert line-breaks
        return false
    }
}
