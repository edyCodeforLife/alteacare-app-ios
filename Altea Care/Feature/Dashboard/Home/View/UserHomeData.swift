//
//  UserHomeData.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 09/06/21.
//

import Foundation

struct UserHomeData : Codable {
    let id : String
    let userPhoto : String
    let ageYear : Int
    let ageMonth : Int
    let nameUser : String
    let email: String
    let dateOfBirth: String
    let gender: String
    let phone: String
    let city: String
}
