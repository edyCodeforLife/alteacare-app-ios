//
//  DetailAppointmentResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/07/21.
//

import Foundation

// MARK: -
struct DetailAppointmentResponse: Codable {
    let status: Bool
    let message: String
    let data: DetailAppointmentData?
}

// MARK: -
struct DetailAppointmentData: Codable {
    let id: Int
    let orderCode, status: String
    let symptomNote: String?
    let schedule: ScheduleResponse
    let doctor: DoctorResponse
    let user: UserDetailResponse
    let medicalResume: MedicalResumeResponse?
    let medicalDocument: [MedicalDocumentResponse]
    let fees: [FeeResponse]
    let totalPrice: Double
    let history: [HistoryResponse]
    let created: String
    let patient: ParentUser?
    let parentUser: ParentUser?
    let transaction: TransactionResponse?
    let statusDetail: StatusDetailResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderCode
        case status
        case symptomNote
        case doctor, user
        case schedule
        case medicalResume
        case medicalDocument
        case fees, history, created
        case totalPrice
        case patient
        case parentUser
        case transaction
        case statusDetail
    }
}

