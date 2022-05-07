//
//  PatientDataModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit

struct PatientDataModel {
    let name: String?
    let age: String?
    let birthday: Date
    let sex: String?
    let idCard: String?
    let phone: String?
    let email: String?
    let address: String?
    let status: ConsultationStatus
    let doctor: DoctorCardModel?
    var documents: [MedicalDocumentItem]
    let diagnosis: String?
    let schedule: Schedule?
    let appointment: Appointment?
}

struct DoctorCardModel {
    let id: String?
    let doctorImage: String?
    let hospitalIcon: String?
    let name: String?
    let specialty: String?
    let hospitalName: String?
    var date: String?
    var time: String?
    let hospitalId: String?
}

struct Appointment {
    let id: Int
    let orderCode: String
}

struct Schedule {
    let date: Date
    let dateString: String
    let timeStart: String
    let timeEnd: String
    var time: String
    let userCalendar = Calendar.current
    
    private func getConsultationDate() -> Date {
        // Set Event Date
        var consultationDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
        // set event time
        let startTime = timeStart.components(separatedBy: ":")
        if startTime.count == 2{
            consultationDateComponents.hour = Int(startTime[0]) ?? 00
            consultationDateComponents.minute = Int(startTime[1]) ?? 00
        }
        consultationDateComponents.second = 00
        consultationDateComponents.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT+7")
        // Convert eventDateComponents to the user's calendar
        let eventDate = userCalendar.date(from: consultationDateComponents)!
        return eventDate
    }
    
    func getCountDownLabel() -> String {
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: DateTime.getCurrentDate(), to: getConsultationDate())
        
        // Display Countdown
        return  (timeLeft.day! > 0 ? "\(timeLeft.day!) Hari": String(format: "%02d:%02d:%02d ",timeLeft.hour!,timeLeft.minute!,timeLeft.second!))
    }
    
    func isConsultationStarted() -> Bool {
        return DateTime.getCurrentDate() >= getConsultationDate()
    }
}

struct Files {
    let filename: String
    let filesize: String
}

class Media {
    var key: String
    var fileName: String
    var data: Data
    var mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = "file"
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
    
    init?(key: String, mimeType: String, fileName: String, data: Data){
        self.key = key
        self.mimeType = mimeType
        self.fileName = fileName
        self.data = data
    }
}
