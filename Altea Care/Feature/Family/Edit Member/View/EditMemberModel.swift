//
//  EditMemberModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

struct EditMemberModel {
    let cardId: String
    let birthDate: String
    let firstName: String
    let id, gender, addressId: String
    let lastName, birthPlace: String
    let city: City
    let district: City
    let country: BirthCountry
    let subDistrict: SubDistrict
    let street, rtRw: String
    let cardType: String
    let familyRelationType: City
    let birthCountry: BirthCountry
    let nationality: BirthCountry
    let status: String
    
    let isDefault: Bool
}
