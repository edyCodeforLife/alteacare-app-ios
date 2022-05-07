//
//  AnalyticsEventTracker.swift
//  Altea Care
//
//  Created by Hedy on 11/09/21.
//

import Foundation

enum AnalyticsEventTracker {
    case registration(AnalyticsRegistration)
    case bookSchedule(AnalyticsBookSchedule)
    case callMA(AnalyticsCallMA)
    case payment(AnalyticsPayment)
    case callDoctor(AnalyticsCallDoctor)
    case transactionDone(AnalyticsTransactionDone)
    case vaccineRegistration(AnalyticsVaccineRegistration)
    case specialistCategory(AnalyticsSpecialistCategory)
    case searchResult(AnalyticsSearchResult)
    case viewDoctorProfile(AnalyticsViewDoctorProfile)
    case medicalMoeNotes(AnalyticsMoeMedicalNotes)
    case medicalOtherNotes
    case searchKeyword(AnalyticsSearchKeyword)
    case filterDayInCategory(AnalyticsFilterDayCategory)
    
    func getName(_ provider: AnalyticsProvider) -> String? {
        switch self {
        case .registration:
            switch provider {
            case .moengage:
                return "Registration"
            case .facebook, .firebase:
                return "REGISTRATION"
            }
        case .bookSchedule:
            switch provider {
            case .moengage:
                return "Booking Schedule"
            case .facebook, .firebase:
                return "BOOKING_SCHEDULE"
            }
        case .callMA:
            switch provider {
            case .moengage:
                return "MA Call"
            case .facebook, .firebase:
                return "MA_CALL"
            }
        case .payment:
            return "payment"
            ///BACKEND PROVIDE SOON
        case .callDoctor:
            switch provider {
            case .moengage:
                return "Doctor Call"
            case .facebook, .firebase:
                return "DOCTOR_CALL"
            }
        case .transactionDone:
            return "transaction_done"
            ///BACKEND PROVIDE SOON
        case .vaccineRegistration:
            return "vaccine_registration"
        case .specialistCategory:
            switch provider {
            case .moengage:
                return "Specialist Category"
            case .facebook, .firebase:
                return "SPECIALIST_CATEGORY"
            }
        case .searchResult:
            switch provider {
            case .moengage:
                return "General Search Result"
            case .facebook, .firebase:
                return "GENERAL_SEARCH_RESULT"
            }
        case .viewDoctorProfile:
            switch provider {
            case .moengage:
                return "Doctor Profile"
            case .facebook, .firebase:
                return "DOCTOR_PROFILE"
            }
        case .medicalMoeNotes:
            switch provider {
            case .moengage:
                return "Medical Notes"
            case .facebook, .firebase:
                return nil
            }
        case .medicalOtherNotes:
            switch provider {
            case .moengage:
                return nil
            case .facebook, .firebase:
                return "MEDICAL_NOTES"
            }
        case .searchKeyword:
            switch provider {
            case .moengage:
                return "Parameter General Search"
            case .facebook, .firebase:
                return "PARAMETER_GENERAL_SEARCH"
            }
        case .filterDayInCategory:
            switch provider {
            case .moengage:
                return "Choosing Day"
            case .facebook, .firebase:
                return "CHOOSING_DAY"
            }
        }
    }
    
    func getParameter(_ provider: AnalyticsProvider) -> AnalyticsParameters? {
        switch self {
        case .registration(let param):
            return param
        case .bookSchedule(let param):
            return param
        case .callMA(let param):
            switch provider {
            case .moengage:
                return param
            case .facebook:
                return AnalyticsFBCallMA(roomCode: param.roomCode)
            case .firebase:
                return param
            }
        case .payment(let param):
            return param
        case .callDoctor(let param):
            switch provider {
            case .moengage:
                return param
            case .facebook:
                return AnalyticsFBCallDoctor(doctorId: param.doctorId, hospitalId: param.hospitalId, hospitalName: param.hospitalName, hospitalArea: param.hospitalArea, diagnosis: param.diagnosis)
            case .firebase:
                return param
            }
        case .transactionDone(let param):
            return param
        case .vaccineRegistration(let param):
            return param
        case .specialistCategory(let param):
            return param
        case .searchResult(let param):
            switch provider {
            case .moengage:
                return param
            case .facebook:
                return AnalyticsFBSearchResult(filterSpecialistCategory: param.filterSpecialistCategory, filterSymptom: param.filterSymptom)
            case .firebase:
                return param
            }
        case .viewDoctorProfile(let param):
            switch provider {
            case .moengage:
                return param
            case .facebook:
                return AnalyticsFBViewDoctorProfile(specialty: param.specialty)
            case .firebase:
                return param
            }
        case .medicalMoeNotes(let param):
            return param
        case .medicalOtherNotes:
            return nil
        case .searchKeyword(let param):
            return param
        case .filterDayInCategory(let param):
            return param
        }
    }
}
