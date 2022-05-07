//
//  CreateBookingModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

struct CreateBookingModel: Codable {
    let id: String?
    let nameDoctor: String?
    let idDoctor: String?
    let photoDoctor: String?
    let iconHospital: String?
    let nameHospital: String?
    let idHospital: String?
    let dateSchedule: String?
    let timeSchedule: String?
    let price: Double?
    let priceFormatted: String?
    var namePatient: String?
    var agePatient: String?
    var dateOfBirthPatient: String?
    var genderPatient: String?
    var phonePatient: String?
    var emailPatient: String?
    let specializationDoctor: String?
    let timeStart: String?
    let timeEnd: String?
    let timeCode: String?
    let promoPriceFormatted: String?
    let promoPriceRaw: Double?
}

struct PatientBookingModel{
    let id: String
    let namePatient: String?
    let agePatient: String?
    let dateOfBirthPatient: String?
    let genderPatient: String?
    let email : String?
    let phone : String?
}
