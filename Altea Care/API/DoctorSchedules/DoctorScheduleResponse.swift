//
//  DoctorScheduleResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation

// MARK: - DoctorScheduleResponse
struct DoctorScheduleResponse: Codable {
    let status: Bool
    let message: String
    let data: [DoctorScheduleData]
}

// MARK: - Datum
struct DoctorScheduleData: Codable {
    let code, date, startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case code, date
        case startTime
        case endTime
    }
}
