//
//  ConsultationModel.swift
//  Altea Care
//
//  Created by Ridwan Abdurrasyid on 01/03/22.
//

import UIKit

struct ConsultationModel {
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
    let dateSchedule: String?
    let patientFamilyMember: ParentUser?
}
