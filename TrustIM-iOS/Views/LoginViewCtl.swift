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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
        navigationItem.hidesBackButton = true
        title = "Login"
    
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailInput.roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
        emailInput.delegate = self
        loginFormView.addSubview(emailInput)
        
        let passwordInput = TITextField()
        passwordInput.placeholder = "Password"
        passwordInput.backgroundColor = UIColor.white
        passwordInput.isSecureTextEntry = true
        // passwordInput.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5.0)
        loginFormView.addSubview(passwordInput)
        
        let font = UIFont(name: (emailInput.font?.fontName)!, size: 13.0)
        emailInput.font = font
        passwordInput.font = font
        
        loginFormView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(100)
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
        if !keyboardNeedLayout {
            return
        }
        
        let kbRect = (aNotification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let view = self.formView!
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            var frame = view.frame
            frame.origin.y -= (kbRect?.height)! / 3
            view.frame = frame
            self.keyboardNeedLayout = false
            }, completion: nil)
    }
    
    func keyboardWillBeHidden(aNotification: Notification) {
        
        let kbRect = (aNotification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
 
        let view = self.formView!
        var frame = view.frame
        frame.origin.y += (kbRect?.height)! / 3
        view.frame = frame
        keyboardNeedLayout = true
    }
}

extension LoginViewCtl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}
