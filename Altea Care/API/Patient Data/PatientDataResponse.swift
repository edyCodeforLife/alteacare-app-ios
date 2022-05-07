//
//  PatientDataResponse.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation

 //MARK: - DetailConsultationResponse
struct PatientDataResponse: Codable {
    let apiVersion, memoryUsage, elapseTime, lang: String?
    let code: Int?
    let error: ErrorConsultation?
    let data: PatientData?

    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case memoryUsage = "memory_usage"
        case elapseTime = "elapse_time"
        case lang, code, error, data
    }
}

struct PatientData: Codable {
    let id: Int?
    let orderNumber: String?
    let schedule: ScheduleDetailConsultation?
    let doctor: DoctorResponse?
    let user: UserDetailConsultation?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case schedule, doctor, user
    }
}

 //MARK: - Schedule
struct ScheduleDetailConsultation: Codable {
    let id, date, endTime: String?

    enum CodingKeys: String, CodingKey {
        case id, date
        case endTime = "end_time"
    }
}

 //MARK: - User
struct UserDetailConsultation: Codable {
    let userID: Int?
    let firstName, lastName, email: String?
    let phone: Phone?
    let gender, birthdate: String?
    let age: Age?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, email, phone, gender, birthdate, age
    }
}

 //MARK: - Age
struct Age: Codable {
    let year, month: Int?
}

 //MARK: - Phone
struct Phone: Codable {
    let raw, formatted: String?
}

 //MARK: - Error Response
struct ErrorConsultation : Codable{
    let message: String?
    let Errors: [ErrorDetail]?
}

struct ErrorDetail : Codable{
    let code: Int?
    let messsage: String?
}
