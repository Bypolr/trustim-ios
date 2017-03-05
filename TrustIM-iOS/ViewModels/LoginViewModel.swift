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

class LoginViewModel {
    var formValid: Driver<Bool>?
    
    func login(email: Driver<String>, password: Driver<String>) {
        // let emailValid = Observerable
        // let password = Observable
    }
}
