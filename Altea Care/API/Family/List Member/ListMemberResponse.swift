//
//  ListMemberResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

// MARK: - ListMemberResponse
struct ListMemberResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ListMemberData?
}

// MARK: - DataClass
struct ListMemberData: Codable {
    let meta: Meta?
    let patient: [Patient]
}

// MARK: - Meta
struct Meta: Codable {
    let page, limit, totalPage, totalData: Int?

    enum CodingKeys: String, CodingKey {
        case page, limit
        case totalPage
        case totalData
    }
}

// MARK: - Patient
struct Patient: Codable {
    let id, refId: String?
    let familyRelationType: City?
    let firstName, lastName, email, phone: String?
    let gender: String?
    let birthCountry: BirthCountry?
    let birthPlace, birthDate: String?
    let age: Age?
    let nationality: BirthCountry?
    let street, rtRw: String?
    let country, province: BirthCountry?
    let city, district: City?
    let subDistrict: SubDistrict?
    let cardType, cardId: String?
    let cardPhoto: CardPhoto?
    let addressId: String?
    let externalPatientId: ExternalPatientID?
    let insurance: String?
    let status: String?
    let isValid, isDefault, isRegistered: Bool?
    let userAddresses: [UserAddress]

    enum CodingKeys: String, CodingKey {
        case id
        case refId
        case familyRelationType
        case firstName
        case lastName
        case email, phone, gender
        case birthCountry
        case birthPlace
        case birthDate
        case age, nationality, street
        case rtRw
        case country, province, city, district
        case subDistrict
        case cardType
        case cardId
        case cardPhoto
        case addressId
        case externalPatientId
        case insurance, status
        case isValid
        case isDefault
        case isRegistered
        case userAddresses
    }
}

// MARK: - CardPhoto
struct CardPhoto: Codable {
    let id, sizeFormatted: String?
    let url: String?
    let formats: Formats?

    enum CodingKeys: String, CodingKey {
        case id
        case sizeFormatted
        case url, formats
    }
}

// MARK: - Formats
struct Formats: Codable {
    let thumbnail, large, medium, small: String?
}

// MARK: - ExternalPatientID
struct ExternalPatientID: Codable {
//    let sapMikaKenjeran, sapMikaGadingSerpong, hisMikaBekasiTimur, sapMikaBintaro: String
//    let sapMikaKalideres: String
//
//    enum CodingKeys: String, CodingKey {
//        case sapMikaKenjeran = "SAP_MIKA_KENJERAN"
//        case sapMikaGadingSerpong = "SAP_MIKA_GADING_SERPONG"
//        case hisMikaBekasiTimur = "HIS_MIKA_BEKASI_TIMUR"
//        case sapMikaBintaro = "SAP_MIKA_BINTARO"
//        case sapMikaKalideres = "SAP_MIKA_KALIDERES"
//    }
}

