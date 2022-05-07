//
//  DetailConsultationResponse.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation

// MARK: - DetailConsultationResponse
struct DetailConsultationResponse: Codable {
    let status: Bool
    let message: String
    let data: DetailConsultationItem?
}

// MARK: - DataClass
struct DetailConsultationItem: Codable {
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
    let totalDiscount: Double?
    let totalOriPrice: Double?
    let history: [HistoryResponse]
    let created: String
    let transaction: TransactionModel?
    
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
        case totalDiscount
        case totalOriPrice
        case transaction
    }
}

// MARK: - Fee
struct FeeResponse: Codable {
    let category: String?
    let amount: Double?
    let status: String?
    let id: Int?
    let createdAt, label: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case category, amount, status, id
        case createdAt
        case label, type
    }
}

// MARK: - History
struct HistoryResponse: Codable {
    let id: Int
    let status, label, created: String
    
    enum CodingKeys: String, CodingKey {
        case id, status, label
        case created
    }
}

// MARK: - MedicalDocument
struct MedicalDocumentResponse: Codable {
    let id: Int
    let url: String
    let originalName, size: String
    let uploadByUser: Int
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case originalName
        case size
        case uploadByUser
    }
}

// MARK: - MedicalResume
struct MedicalResumeResponse: Codable {
    let symptom, diagnosis, drugResume, additionalResume: String
    let consultation, notes: String
    
    enum CodingKeys: String, CodingKey {
        case symptom, diagnosis
        case drugResume
        case additionalResume
        case consultation, notes
    }
}

// MARK: - User
struct UserDetailResponse: Codable {
    let id: String
    let name, birthdate, gender, phoneNumber: String
    let email: String
    let addressRaw: [UserAddress]?
    let cardId: String?
    let age: AgeResponse
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthdate, gender
        case phoneNumber
        case email
        case addressRaw
        case cardId
        case age
    }
}

// MARK: - Age
struct AgeResponse: Codable {
    let year, month: Int
}

// MARK: - Transaction
struct TransactionModel: Codable{
    let type, bank: String?
    let detail: TransactionDetailModel?
    
    enum CodingKeys: String, CodingKey {
        case type, bank
        case detail
    }
}

struct TransactionDetailModel: Codable {
    let name, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case name, icon
    }
}
