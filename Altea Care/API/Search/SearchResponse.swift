//
//  SearchResponse.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation

class SearchResponse: Codable {
    let status: Bool
    let message: String
    let meta: MetaSearch
    let data: DataDoctorEverything
}

struct MetaSearch: Codable {
    let totalDoctor: Int
    let totalSymtom: Int
    let totalSpecialization: Int
    
    enum CodingKeys: String, CodingKey {
        case totalDoctor
        case totalSymtom
        case totalSpecialization
    }
}

struct DataDoctorEverything: Codable {
    let specialization: [EverythingSpecializationModel]
    let doctor: [EverthingDoctorItemModel]
    let symtom: [EverythingSymtomModel]
    
    
    enum CodingKeys: String, CodingKey {
        case specialization
        case doctor
        case symtom
    }
}

struct EverthingDoctorItemModel: Codable {
    let doctorId, name, experience, overview, about: String?
    let photo: EverythingPhotoDoctorItemModel?
    let specialization: EverythingDoctorSpecialization?
    let price: EverythingPriceModel
    let hospital: [EverythingDoctorHospitalModel]
    let flatPrice: PriceDoctorModel?
    let originalPrice: PriceDoctorModel?
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case doctorId, name, experience, overview, about
        case photo
        case specialization
        case price
        case hospital
        case flatPrice
        case isAvailable
        case originalPrice
    }
}

struct EverythingDoctorSpecialization: Codable {
    let id, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct EverythingPhotoDoctorItemModel: Codable{
    let url: String?
    let formats: EverthingImageFormatModel
    
    enum CodingKeys: String, CodingKey {
        case url
        case formats
    }
}

struct EverthingImageFormatModel: Codable {
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

struct EverythingSpecializationModel: Codable {
    let specializationId: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case specializationId
        case name
    }
}

struct EverythingSymtomModel: Codable {
    let symtomId: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case symtomId
        case name
    }
}

struct EverythingPriceModel: Codable {
    let raw: Int?
    let formatted: String?
    
    enum CodingKeys: String, CodingKey {
        case raw
        case formatted
    }
}

struct EverythingDoctorHospitalModel: Codable {
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
