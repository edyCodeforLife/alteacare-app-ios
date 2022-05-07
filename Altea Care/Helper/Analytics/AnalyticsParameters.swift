//
//  AnalyticsParameters.swift
//  Altea Care
//
//  Created by Hedy on 11/09/21.
//

import Foundation

protocol AnalyticsParameters: Codable { }

struct AnalyticsUserData {
    let id: String?
    let name, email: String?
    var mobilePhone: String?
    let gender: String?
    let birthDate: Date?
    let age: Int?
    var isPregnant: Bool?
}

struct AnalyticsRegistration: AnalyticsParameters {
    let userId: String?
    let name: String?
    let gender: String?
    let email: String?
    let phone: String?
    let city: String?
    let signupMethod: String?
    let userDob: String?
}

struct AnalyticsBookSchedule: AnalyticsParameters {
    let hospitalId: String?
    let hospitalName: String?
    let hospitalArea: String?
    let bookingDay: String?
    let bookingDate: String?
    let bookingHours: String?
    let doctorId: String?
    let doctorName: String?
    let doctorSpeciality: String?
}

struct AnalyticsCallMA: AnalyticsParameters {
    let appointmentId: String?
    let orderCode: String?
    let roomCode: String?
}

struct AnalyticsFBCallMA: AnalyticsParameters {
    let roomCode: String?
}

struct AnalyticsPayment: AnalyticsParameters {
    let paymentStatus: String?
    let paymentMethod: String?
    let paymentTime: String?
    let paymentId: String?
    let transactionValue: Int?
    let discountId: Int?
    let discountName: String?
    let discountValue: Int?
}

struct AnalyticsCallDoctor: AnalyticsParameters {
   let doctorId: String?
   let doctorName: String?
   let doctorSpecialist: String?
   let hospitalId: String?
   let hospitalName: String?
   let hospitalArea: String?
   let diagnosis: String?
}

struct AnalyticsFBCallDoctor: AnalyticsParameters {
   let doctorId: String?
   let hospitalId: String?
   let hospitalName: String?
   let hospitalArea: String?
   let diagnosis: String?
}

struct AnalyticsTransactionDone: AnalyticsParameters {
    let sessionStatus: Bool?
}

struct AnalyticsVaccineRegistration: AnalyticsParameters {
   let vaccineDate: String?
   let vaccinePlace: String?
   let userName: String?
   let userPhone: String?
   let userEmail: String?
}

struct AnalyticsSpecialistCategory: AnalyticsParameters {
    let categoryId: String?
    let specialistCategoryName: String?
}

struct AnalyticsSearchResult: AnalyticsParameters {
    let filterSpecialistCategory: String?
    let filterDoctorName: String?
    let filterSymptom: String?
}

struct AnalyticsFBSearchResult: AnalyticsParameters {
    let filterSpecialistCategory: String?
    let filterSymptom: String?
}

struct AnalyticsViewDoctorProfile: AnalyticsParameters {
    let doctorId: String?
    let doctorName: String?
    let specialty: String?
}

struct AnalyticsFBViewDoctorProfile: AnalyticsParameters {
    let specialty: String?
}

struct AnalyticsMoeMedicalNotes: AnalyticsParameters {
    let diagnosis: String?
    let keluhan: String?
    let resepObat: String?
    let rekomendasiDokter: String?
    let catatanLain: String?
}

struct AnalyticsSearchKeyword: AnalyticsParameters {
    let searchResult: String?
}

struct AnalyticsFilterDayCategory: AnalyticsParameters {
    let choosingDay: String?
}
