//
//  CancelConsultationModel.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit

struct CancelConsultation {
    let isFullyLoaded: Bool
    let model: [CancelConsultationModel]
}

struct CancelConsultationModel {
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
    var hospitalIcon: String
    var doctorImage: String
//    let reason: String
    let reason: InfoCase
    let transaction: ConsultationTransactionModel?
    let patientFamilyMember: ParentUser?
    let dateSchedule: String?
}

enum InfoCase: String {
    case paymentExpired = "PAYMENT_EXPIRED"
    case paymentFailed = "PAYMENT_FAILED"
    case refund = "REFUND"
    case userCanceled = "CANCEL_BY_USER"
    case gpCanceled = "CANCEL_BY_GP"
    case systemCanceled = "CANCELED_BY_SYSTEM"
    case unknown = ""
    
    var text: String {
        switch self {
        case .paymentExpired, .paymentFailed:
            return "Maaf, Masa Pembayaran telah berakhir, silahkan buat telekonsultasi ulang untuk telekonsultasi dengan "
        case .refund:
            return "Proses Refund membutuhkan kurang lebih 3 hari kerja."
        case .gpCanceled:
            return "Transaksi telah dibatalkan oleh GP Escort"
        case .userCanceled:
            return "Transaksi telah dibatalkan oleh Pengguna"
        case .systemCanceled:
            return "Transaksi telah dibatalkan oleh Sistem"
        case .unknown:
            return "-"
        }
    }
}

extension CancelConsultationModel {
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
