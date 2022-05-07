//
//  GetUserResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

// MARK: - GetUserResponse
struct GetUserResponse: Codable {
    let status: Bool
    let message: String
    let data: DataUser?
}

// MARK: - DataClass
struct DataUser: Codable {
    let id, email, phone, firstName: String?
    let lastName: String?
    let isVerifiedEmail, isVerifiedPhone: Bool?
    let userRole: [String]?
    let userDetails: UserDetails?
    let userAddresses: [UserAddress]?

    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName
        case lastName
        case isVerifiedEmail
        case isVerifiedPhone
        case userRole
        case userDetails
        case userAddresses
    }
}

extension UserAddress {
    
    var fullAdress: String {
        return "\(street ?? ""), RT/RW \(rtRw ?? ""), Kel. \(subDistrict?.name ?? ""), Kec. \(district?.name ?? ""), \(city?.name ?? "") \(province?.name ?? "") \(subDistrict?.postalCode ?? "")"
    }
}

struct UserAddress: Codable {
    let type, street, rtRw: String?
    let country, province: BirthCountry?
    let city, district: City?
    let subDistrict: SubDistrict?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case type, street
        case rtRw
        case country, province, city, district
        case subDistrict
        case latitude, longitude
    }
}

// MARK: - SubDistrict
struct SubDistrict: Codable {
    let id, name, geoArea, postalCode: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case geoArea
        case postalCode
    }
}

struct City: Codable {
    let id, name: String?
}

//MARK: - User Details
struct UserDetails: Codable {
    let idCard: String?
    let sapPatientId: String?
    let gender, birthDate, birthPlace: String?
    let birthCountry, nationality: BirthCountry?
    let photoIdCard: PhotoIDCard?
    let avatar: Avatar?
    let age: Age?

    enum CodingKeys: String, CodingKey {
        case idCard
        case sapPatientId
        case gender
        case birthDate
        case birthPlace
        case birthCountry
        case nationality
        case photoIdCard
        case avatar, age
    }
}

struct PhotoIDCard: Codable {
    let id: String?
    let url: String?
    let formats: IconFormats?
}

struct Avatar: Codable {
    let url: String?
    let formats: IconFormats?
}
// MARK: - Age
struct AgeUser: Codable {
    let year, month: Int?
}

// MARK: - BirthCountry
struct BirthCountry: Codable {
    let id, code, name: String?
}
