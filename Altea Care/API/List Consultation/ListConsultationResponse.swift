//
//  ListConsultationResponse.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation

// MARK: - ListConsultationResponse
struct ListConsultationResponse: Codable {
    let status: Bool
    let message: String
    let meta: MetaResponse
    let data: [ListConsultationItem]?
    enum CodingKeys: String, CodingKey {
        case status, message, meta, data
    }
}

// MARK: - Meta
struct MetaResponse: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPage: Int
    enum CodingKeys: String, CodingKey {
        case page, perPage, total, totalPage
    }
}

// MARK: - Datum
//struct ListConsultationItem: Codable {
//    let id: Int
//    let orderCode, status: String
//    let statusDetail: StatusDetailResponse
//    let schedule: ScheduleResponse?
//    let doctor: DoctorResponse
//    let user: UserResponse
//    let transaction: TransactionResponse?
//    let created: String
//    let patient: ParentUser?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case orderCode
//        case status, schedule, doctor, user, created, statusDetail, transaction,patient
//    }
//}

struct ListConsultationItem: Codable {
    let statusDetail: StatusDetailResponse?
    let externalCaseNo: String?
    let doctor: DoctorResponse?
    let status, patientId: String?
    let transaction: TransactionResponse?
    let created, userId: String?
    let totalDiscount: Int?
    let externalAppointmentId, canceledNotes: String?
    let schedule: ScheduleResponse?
    let externalPatientId: String?
    let fees: [FeeResponse]?
    let patient: ParentUser?
    let id: Int?
    let user: ParentUser?
    let totalPrice, totalOriginalPrice, totalVoucher: Int?
    let insName, consultationMethod, insNo: String?
    let parentUser: ParentUser?
    let orderCode: String?

    enum CodingKeys: String, CodingKey {
        case statusDetail
        case externalCaseNo
        case doctor, status
        case patientId
        case transaction, created
        case userId
        case totalDiscount
        case externalAppointmentId
        case canceledNotes
        case schedule
        case externalPatientId
        case fees, patient, id, user
        case totalPrice
        case totalOriginalPrice
        case totalVoucher
        case insName
        case consultationMethod
        case insNo
        case parentUser
        case orderCode
    }
}

// MARK: - Tramsactopm
struct TransactionResponse: Codable {
    let bank: String?
    let type: String?
    let vaNumber: String?
    let refId: String?
    let total: Double?
    let expiredAt: String?
    let paymentUrl: String?
}


// MARK: - Status Detail
struct StatusDetailResponse: Codable {
    let label: String
    let textColor: String
    let bgColor: String
}

// MARK: - Doctor
struct DoctorResponse: Codable {
    let id: String
    let name: String
    let photo: PhotoResponse?
    let specialist: SpecialistResponse
    let hospital: HospitalResponse

    enum CodingKeys: String, CodingKey {
        case id, name, photo, specialist, hospital
    }
}

// MARK: - Photo
struct PhotoResponse: Codable {
    let url: String
    let formats: PhotoFormatResponse
}

// MARK: - Photo Format
struct PhotoFormatResponse: Codable {
    let thumbnail: String
    let large: String
    let medium: String
    let small: String
}

// MARK: - Hospital
struct HospitalResponse: Codable {
    let id: String?
    let name: String
    let logo: String
}

struct HospitalLogoResponse: Codable {
    let url: String?
    let formats: String?
}

// MARK: - Specialist
struct SpecialistResponse: Codable {
    let id: String
    let name: String
    let child: UserResponse?
}

// MARK: - User
struct UserResponse: Codable {
    let id: String
    let name: String
}

// MARK: - Schedule
struct ScheduleResponse: Codable {
    let id: Int
    let code, date: String
    let timeStart: String?
    let timeEnd: String?

    enum CodingKeys: String, CodingKey {
        case id, code, date
        case timeStart, timeEnd
        
    }
}

// MARK: - ParentUser
struct ParentUser: Codable {
    let id, lastName, type, name: String?
    let firstName: String?
    let familyRelationType: City? // for "patient"

    enum CodingKeys: String, CodingKey {
        case id
        case lastName
        case type, name
        case firstName
        case familyRelationType
    }
}
