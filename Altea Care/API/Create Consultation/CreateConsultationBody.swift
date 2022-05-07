//
//  CreateConsultationBody.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 31/05/21.
//

import Foundation

struct CreateConsultationBody: Codable {
    let doctorId: String
    let symptomNote: String
    ///for family member make appointment
    let patientId : String?
    let consultationMethod: String
    let nextStep: String
    let refferenceAppointmentId: String
    let schedules: [CreateConsultationSchedule]
    
    enum CodingKeys: String, CodingKey {
        ///for family member make appointment
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case symptomNote = "symptom_note"
        case consultationMethod = "consultation_method"
        case nextStep = "next_step"
        case refferenceAppointmentId = "refference_appointment_id"
        case schedules = "schedules"
    }
}


struct CreateConsultationSchedule: Codable {
    let code: String?
    let date: String?
    let startTime: String?
    let endTime: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case date = "date"
        case startTime = "time_start"
        case endTime = "time_end"
    }
}
