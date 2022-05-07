//
//  OngoingConsultationModel.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit

struct OngoingConsultation {
    let isFullyLoaded: Bool
    let model: [OngoingConsultationModel]
}

struct OngoingConsultationModel {
    let id: String
    var orderCode: String
    var status: ConsultationStatus
    var statusDetail: String
    var statusBgColor: UIColor
    var statusTextColor: UIColor
    var hospitalName: String
    var doctorName: String
    var specialty: String
    var date: Date?
    var time: String
    var startTime: String
    var hospitalIcon: String
    var doctorImage: String
    let transaction: ConsultationTransactionModel?
    let dateSchedule: String?
    let patientFamilyMember: ParentUser?
}


struct SelectionFilterModel {
    let type: SelectionFilter
    var isHighlighted: Bool
    
    static var basic: [SelectionFilterModel] {
        return SelectionFilter.allCases.map { SelectionFilterModel(type: $0, isHighlighted: false) }
    }
}

struct SelectionFilterMyConsultationModel {
    let type: SelectionFilter
    
    static var basic: [SelectionFilterMyConsultationModel] {
        return SelectionFilter.allCases.map {SelectionFilterMyConsultationModel(type: $0)}
    }
}

enum SelectionFilter: CaseIterable {
    case today
    case thisWeek
    case others
    
    var label: String {
        switch self {
        case .today:
            return "Hari Ini"
        case .thisWeek:
            return "Minggu Ini"
        case .others:
            return "Hari Lain"
        }
    }
}

struct ConsultationTransactionModel {
    let bank: String
    let redirectionType: TransactionRedirectionType
    let vaNumber: String?
    let refId: String?
    let total: Double?
    let expiredAt: String?
    let paymentUrl: String?
}

enum TransactionRedirectionType: String {
    case webview = "ALTEA_PAYMENT_WEBVIEW"
    case midtrans = "ALTEA_PAYMENT_MIDTRANS"
    case unkown
}

enum ConsultationStatus: String {
    case done = "COMPLETED"
    case cancel = "CANCEL"
    case new = "NEW"
    case gpProcess = "PROCESS_GP"
    case meetTheDoctor = "PAID"
    case waitingForPayment = "WAITING_FOR_PAYMENT"
    case processingResume = "WAITING_FOR_MEDICAL_RESUME"
    case ongoing = "ON_GOING"
    case paymentExpired = "PAYMENT_EXPIRED"
    case paymentFailed = "PAYMENT_FAILED"
    case refund = "REFUNDED"
    case userCanceled = "CANCELED_BY_USER"
    case gpCanceled = "CANCELED_BY_GP"
    case meetSpecialist = "MEET_SPECIALIST"
    case unknown = ""
    
    var label: String {
        switch self {
        case .done:
            return "Selesai"
        case .cancel:
            return "Batal"
        case .new:
            return "Transaksi Baru"
        case .gpProcess:
            return "Transaksi diproses"
        case .meetTheDoctor:
            return "Temui Dokter"
        case .waitingForPayment:
            return "Menunggu pembayaran"
        case .processingResume:
            return "Resume medis diproses"
        case .ongoing:
            return "Sedang berjalan"
        case .paymentExpired:
            return "Pembayaran Expired"
        case .paymentFailed:
            return "Pembayaran Gagal"
        case .refund:
            return "Transaksi Refund"
        case .userCanceled:
            return "Transaksi Batal"
        case .gpCanceled:
            return "Transaksi Batal"
        case .meetSpecialist:
            return "Temui Specialist"
        case .unknown:
            return "NONE"
        }
    }
}

extension OngoingConsultationModel {
    func generalized() -> ConsultationModel {
        return ConsultationModel(
            orderCode:  self.orderCode,
            status:  self.status,
            statusDetail:  self.statusDetail,
            statusBgColor:  self.statusBgColor,
            statusTextColor:  self.statusTextColor,
            hospitalName:  self.hospitalName,
            doctorName:  self.doctorName,
            specialty:  self.specialty,
            date:  self.date,
            time:  self.time,
            hospitalIcon:  self.hospitalIcon,
            doctorImage:  self.doctorImage,
            dateSchedule:  self.dateSchedule,
            patientFamilyMember:  self.patientFamilyMember)
    }
}
