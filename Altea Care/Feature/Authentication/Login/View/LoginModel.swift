//
//  LoginModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

struct LoginModel {
    let status : Bool?
    let message : String?
    let isRegistered, isVerified: Bool?
    let accessToken, refreshToken: String?
    let isEmailVerified, isPhoneVerified: Bool?
    let deviceID: String?
}
