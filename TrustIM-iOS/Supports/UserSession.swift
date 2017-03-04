//
//  UserSession.swift
//  TrustIM-iOS
//
//  Created by towry on 02/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import RxSwift

enum SessionActionError: Error {
    case server
    case badResponse
    case badCredentials
}

enum SessionStatus {
    case none
    case error(SessionActionError)
    case created
}

class UserSessionManager {
    
}
