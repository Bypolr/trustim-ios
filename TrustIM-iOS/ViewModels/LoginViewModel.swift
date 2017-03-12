//
//  LoginViewModel.swift
//  TrustIM-iOS
//
//  Created by towry on 02/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities
import Alamofire

enum LoginError {
    case none
    case server
    case invalidCredential
    case badResponse
}

enum LoginStatus {
    case none
    case error(LoginError)
    case user(Int8)
}

class LoginViewModel {
    internal var signinEnabled: Driver<Bool>?
    let activityIndictor: ActivityIndicator = ActivityIndicator()
    
    init(email: Driver<String>, password: Driver<String>) {
        let emailValid: Driver<Bool> = email.distinctUntilChanged()
            .throttle(0.3)
            .map({
                $0.utf8.count > 4
            })
        let passValid: Driver<Bool> = password.distinctUntilChanged()
            .throttle(0.3)
            .map({
                $0.utf8.count > 6
            })
        
        signinEnabled = Driver<Bool>.combineLatest(emailValid, passValid) {
            $0 && $1
        }
    }
    
    func login(email: String, password: String) -> Observable<LoginStatus> {
        let url = URL(string: "http://localhost:9090/login")
        return Observable<LoginStatus>.create({ observer -> Disposable in
            let req = request(url!)
                .responseJSON(completionHandler: { (response) in
                    if let json = response.result.value {
                        guard let data: Dictionary<String, Any> = json as? Dictionary<String, Any>,
                            let id: Int8 = data["id"] as? Int8 else {
                            observer.onNext(.error(.badResponse))
                            observer.onCompleted()
                            return
                        }
                        
                        if id != -1 {
                            observer.onNext(.user(id))
                            observer.onCompleted()
                        } else {
                            // invalid password or email
                            observer.onNext(.error(.invalidCredential))
                            observer.onCompleted()
                        }
                    } else if response.error != nil {
                        observer.onNext(.error(.server))
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create(with: {
                req.cancel()
            })
        }).catchErrorJustReturn(.error(.server))
    }
}
