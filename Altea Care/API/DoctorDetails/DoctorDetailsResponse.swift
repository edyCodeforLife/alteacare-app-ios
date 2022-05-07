//
//  DoctorDetailsResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation

// MARK: - DoctorDetailsResponse
struct DoctorDetailsResponse: Codable {
    let status: Bool
    let message: String
    let data: DataDoctor?
}

// MARK: - DataClass
struct DataDoctor: Codable {
    let doctorId, name, slug: String?
    let isPopular: Bool
    let about, overview: String?
    let photo: ImageModel?
    let sip, experience: String?
    let price: Price
    let specialization: Specialization
    let hospital: [HospitalModel]
    let flatPrice: Price?
    let originalPrice: Price?
    let isAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case doctorId
        case name, slug
        case isPopular
        case about, overview, photo, sip, experience, price, specialization, hospital
        case flatPrice
        case isAvailable
        case originalPrice

        
    }
}

// MARK: - Price
struct Price: Codable {
    let raw: Double
    let formatted: String
}

// MARK: - Specialization
struct Specialization: Codable {
    let id, name: String
}
