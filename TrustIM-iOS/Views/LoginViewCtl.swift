//
//  LoginViewCtl.swift
//  TrustIM-iOS
//
//  Created by towry on 02/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewCtl: BaseViewCtl {
    var delegate: TINavigationDelegate?
    var disposeBag: DisposeBag = DisposeBag()
    var viewModel: LoginViewModel?
    var formView: UIView?
    var keyboardNeedLayout = true
    var formBottomConstraint: Constraint? = nil
    var activityIndictor: UIActivityIndicatorView?
    var password: UITextField!
    var email: UITextField!
    
    lazy var loginBtn: UIButton = {
        let btn = TIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = Refs.Color.primaryColor
        // btn.backgroundColorForHighlight = Refs.Color.primaryColorDarken
        btn.layer.cornerRadius = Refs.Shape.cornerRadius
        btn.layer.borderColor = Refs.Color.primaryColorDarken.cgColor
        
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
        
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gr)
        gr.rx.event.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.email.resignFirstResponder()
                self?.password.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        viewModel = LoginViewModel(email: (email?.rx.text.orEmpty.asDriver())!, password: (password?.rx.text.orEmpty.asDriver())!)
        
        let vm: LoginViewModel = viewModel!
        
        loginBtn.rx.tap
            .withLatestFrom(vm.signinEnabled!)
            .filter({
                $0
            })
            .flatMapLatest({ valid -> Observable<LoginStatus> in
                vm.login(email: self.email.text!, password: self.password.text!)
                .trackActivity(vm.activityIndictor)
                .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (loginstatus: LoginStatus) in
                switch loginstatus {
                case .none:
                    break
                case .error(let err):
                    self?.showError(err)
                    break
                case .user(let id):
                    print("user id: \(id)")
                    break
                }
            })
            .addDisposableTo(disposeBag)
        
        vm.activityIndictor
            .distinctUntilChanged()
            .drive(onNext: { [weak self] active in
                self?.activityIndictor?.isHidden = !active
            })
            .addDisposableTo(disposeBag)
    }

    func afterLoginSuccess() {
        delegate?.loginSuccess()
    }
    
    func showError(_ err: LoginError) {
        let title: String
        let message: String
        
        switch err {
        case .server, .badResponse:
            title = "出错了"
            message = "网络错误"
            break
        case .invalidCredential:
            title = "出错了"
            message = "错误的邮箱地址或者密码"
            break
        default:
            title = "出错了"
            message = "未知错误"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] (_) -> Void in
            self?.afterLoginSuccess()
        })
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
    
    func showIndictor() {
        if (activityIndictor == nil) {
            activityIndictor = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndictor?.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 5)
            activityIndictor?.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.view.addSubview(activityIndictor!)
        }
        activityIndictor?.startAnimating()
    }
    
    func hideIndictor() {
        activityIndictor?.stopAnimating()
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
        email = emailInput
        
        let passwordInput = TITextField()
        passwordInput.placeholder = "Password"
        passwordInput.backgroundColor = UIColor.white
        passwordInput.isSecureTextEntry = true
        passwordInput.tag = 2
        passwordInput.delegate = self
        passwordInput.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Refs.Shape.cornerRadius)
        loginFormView.addSubview(passwordInput)
        password = passwordInput
        
        
        let font = UIFont(name: (emailInput.font?.fontName)!, size: 13.0)
        emailInput.font = font
        passwordInput.font = font
        
        // Login button
        loginFormView.addSubview(loginBtn)
        
        loginFormView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            self.formBottomConstraint = make.centerY.equalTo(view).constraint
            make.width.equalTo(250)
            make.height.equalTo(150)
        }
        
        emailInput.snp.makeConstraints { (make) in
            make.top.equalTo(loginFormView.snp.top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        passwordInput.snp.makeConstraints { (make) in
            make.top.equalTo(emailInput.snp.bottom).offset(-1)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInput.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
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
        let formBottom = v.frame.origin.y + v.bounds.height
        if formBottom >= (kbRect?.origin.y)! {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                let offset = (kbRect?.origin.y)! - formBottom - 30
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
