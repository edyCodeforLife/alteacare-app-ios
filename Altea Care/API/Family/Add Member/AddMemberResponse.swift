//
//  AddMemberResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

// MARK: - AddMemberResponse
struct AddMemberResponse: Codable {
    let status: Bool
    let message: String
    let data: Patient?
}

// MARK: - DataClass
struct AddMemberData: Codable {
    let cardId: String
    let userAddresses: [UserAddress]
    let province: BirthCountry?
    let district: City?
    let status: String
    let country: BirthCountry?
    let birthDate: String
    let subDistrict: SubDistrict?
    let isRegistered: Bool
    let street, rtRw: String?
    let isValid: Bool
    let refId: String
    let city: City?
    let lastName, birthPlace: String
    let nationality: BirthCountry?
    let externalPatientId: ExternalPatientID?
    let cardType: String
    let insurance: String?
    let id, gender, addressId: String?
    let familyRelationType: City
    let birthCountry: BirthCountry
    let age: Age
    let firstName: String
    let cardPhoto: CardPhoto?
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case cardId
        case userAddresses
        case province, district, status, country
        case birthDate
        case subDistrict
        case isRegistered
        case street
        case rtRw
        case isValid
        case refId
        case city
        case lastName
        case birthPlace
        case nationality
        case externalPatientId
        case cardType
        case insurance, id, gender
        case addressId
        case familyRelationType
        case birthCountry
        case age
        case firstName
        case cardPhoto
        case isDefault
    }
}
