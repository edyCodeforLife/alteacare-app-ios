//
//  PayConsultationBody.swift
//  Altea Care
//
//  Created by Tiara on 12/05/21.
//

import Foundation

struct PayConsultationBody: Codable {
    let appointment_id: Int
    let method : String
    let voucher_code : String
}
