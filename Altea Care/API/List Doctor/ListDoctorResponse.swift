//
//  ListDoctorResponse.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 03/05/21.
//

import Foundation

struct ListDoctorResponse: Codable {
    let status: Bool
    let message: String
    let data: [ListDoctorItemModel]
}

struct ListDoctorItemModel: Codable {
    let doctorId: String?
    let name: String?
    let about: String?
    let overview: String?
    let experience: String?
    let photo: ImageModel?
    let price: PriceDoctorModel
    let specialization: SpecializationDoctorModel?
    let hospital: [HospitalModel]?
    let flatPrice: PriceDoctorModel?
    let originalPrice: PriceDoctorModel?
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case doctorId
        case name
        case about
        case overview
        case experience
        case photo
        case price
        case specialization
        case hospital
        case flatPrice
        case isAvailable
        case originalPrice
    }
}

struct PriceDoctorModel: Codable {
    let raw: Int?
    let formatted: String?
    
    enum CodingKeys: String, CodingKey {
        case raw
        case formatted
    }
}

struct SpecializationDoctorModel: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct HospitalModel: Codable {
    let id: String?
    let name: String?
//    let image: ImageModel
//    let icon : ImageModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case image
//        case icon
    }
    
}

struct ImageModel: Codable {
    let url: String?
    let formats: ImageFormatModel
    enum CodingKeys: String, CodingKey {
        case url
        case formats
    }
}

struct ImageFormatModel: Codable {
    let thumbnail: String?
    let large: String?
    let small: String?
    let medium: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case large
        case small
        case medium
    }
}
