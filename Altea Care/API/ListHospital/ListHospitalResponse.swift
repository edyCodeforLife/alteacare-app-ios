//
//  ListHospitalResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation

// MARK: - ForceUpdate
struct ListHospitalResponse: Codable {
    let status: Bool
    let message: String
    let data: [ListDoctorDatum]
}

// MARK: - Datum
struct ListDoctorDatum: Codable {
    let hospitalId, name: String
    let phone, address, latitude, longitude: String?
    let image, icon: IconHospital?
    let externalProvider: ExternalProvider

    enum CodingKeys: String, CodingKey {
        case hospitalId
        case name, phone, address, latitude, longitude, image, icon
        case externalProvider
    }
}

// MARK: - ExternalProvider
struct ExternalProvider: Codable {
    let id, name, code: String
}

// MARK: - Icon
struct IconHospital: Codable {
    let sizeFormatted: String
    let url: String
    let formats: PhotoFormatResponse

    enum CodingKeys: String, CodingKey {
        case sizeFormatted
        case url, formats
    }
}
