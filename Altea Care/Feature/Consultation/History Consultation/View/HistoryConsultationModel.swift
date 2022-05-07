//
//  HistoryConsultationModel.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit

struct HistoryConsultation {
    let isFullyLoaded: Bool
    let model: [HistoryConsultationModel]
}

struct HistoryConsultationModel {
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
    let transaction: ConsultationTransactionModel?
    let patientFamilyMember: ParentUser?
    let dateSchedule: String?
}

extension HistoryConsultationModel {
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
