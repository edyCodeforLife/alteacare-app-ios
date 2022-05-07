//
//  RegisterBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation

struct RegisterBody : Codable {
    let email : String
    let phone : String
    let password : String
    let password_confirmation: String
    let first_name : String
    let last_name : String
    let birth_date : String
    let gender: String
    let birth_place : String
    let birth_country : String
    
    enum CodingKeys: String, CodingKey {
        case email, phone, password
        case password_confirmation
        case first_name
        case last_name
        case birth_date
        case gender
        case birth_place
        case birth_country
    }
}
