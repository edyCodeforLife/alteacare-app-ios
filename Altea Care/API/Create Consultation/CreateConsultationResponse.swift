//
//  CreateConsultationResponse.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 31/05/21.
//

import Foundation

struct CreateConsultationResponse: Codable{
    let status: Bool
    let message: String
    let data: DataCreateConsultation
}

// MARK: - Data Consultation

struct DataCreateConsultation : Codable {
    let appointmentId: Int?
    let orderCode: String?
    let roomCode: String?
    let appointmentMethod: String?
    let status: String?
    let statusDetail : StatusDetail?
    let inOperationalHour: Bool?
    
    enum CodingKeys: String, CodingKey {
        case appointmentId
        case orderCode
        case roomCode
        case appointmentMethod
        case status
        case statusDetail
        case inOperationalHour
    }
}

struct StatusDetail : Codable{
    let label : String
    let textColor : String
    let bgColor : String
    
    enum CodingKeys: String, CodingKey {
        case label
        case textColor
        case bgColor
    }
}
