//
//  ChangeProfileModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

struct ChangeProfileModel {
    let userImage : String?
    let phoneNumber : String?
    let email : String?
    let username : String?
    let ageYear : Int?
    let ageMonth : Int?
    let birthdate : String?
    let idCard : String?
    let gender : String?
    let address : String?
}

struct AddressData {
    let street : String
    let rtRw : String
    let kelurahan : String
    let kecamatan : String
    let kota : String
    let province : String
    let postalCode : String
}
