//
//  SettingModel.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation

struct SettingModel {
    let operationalHourStart: String
    let operationalHourEnd: String
    let userCalendar = Calendar.current
    
    func isInOfficeHour() -> Bool {
        let startTime = operationalHourStart.components(separatedBy: ":")
        let endTime = operationalHourEnd.components(separatedBy: ":")
        var startConsultationDateComponent = Calendar.current.dateComponents([.day, .year, .month], from: DateTime.getCurrentDate())
        var endConsultationDateComponent = Calendar.current.dateComponents([.day, .year, .month], from: DateTime.getCurrentDate())
        let now = DateTime.getCurrentDate()
        
        if startTime.count >= 2 {
            startConsultationDateComponent.hour = Int(startTime[0]) ?? 00
            startConsultationDateComponent.minute = Int(startTime[1]) ?? 00
        }
        if endTime.count >= 2 {
            endConsultationDateComponent.hour = Int(endTime[0]) ?? 00
            endConsultationDateComponent.minute = Int(endTime[1]) ?? 00
        }
        startConsultationDateComponent.second = 00
        endConsultationDateComponent.second = 00
        startConsultationDateComponent.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT+7")
        endConsultationDateComponent.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT+7")
        
        let startConsultation = userCalendar.date(from: startConsultationDateComponent)!
        let endConsultation = userCalendar.date(from: endConsultationDateComponent)!
        return  (startConsultation <= now) && (now <= endConsultation)
        
    }
}
