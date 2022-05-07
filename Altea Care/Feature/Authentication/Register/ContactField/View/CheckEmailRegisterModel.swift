//
//  CheckEmailRegisterModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/08/21.
//

import Foundation

struct CheckEmailRegisterModel {
    let status: Bool
    let message: String
    let data: CheckEmailData
}

// MARK: - DataClass
struct CheckEmailData {
    let isEmailAvailable, isPhoneAvailable: Bool
}
