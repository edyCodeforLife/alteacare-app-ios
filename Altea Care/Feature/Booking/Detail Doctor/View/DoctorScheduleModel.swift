//
//  DoctorScheduleModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation


struct DoctorScheduleModel {
    let status : Bool
    let message : String
    let data : [DoctorScheduleDataModel]?
}
// MARK: - Datum
struct DoctorScheduleDataModel {
    let code, date, startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case code, date
        case startTime
        case endTime 
    }
}

struct DoctorTime {
    var timeClock : String
}

struct DayName {
    var id, day, date: String
}

struct CalenderModel {
    var date : Date
}

