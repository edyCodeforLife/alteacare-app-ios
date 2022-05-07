//
//  ListConsultationBody.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation

struct ListConsultationBody: Codable {
    var keyword: String?
    var sort: String?
    var sortType: String?
    var page: Int?
    var startDate: String?
    var endDate: String?
    
    var patientId:String?
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case sort = "sort_by"
        case sortType = "sort_type"
        case page
        case startDate = "schedule_date_start"
        case endDate = "schedule_date_end"
        case patientId = "patient_id"
    }
    
    mutating func initialPage() {
        self.page = 1
    }
    
    mutating func nextPage() {
        guard let currentPage = self.page else {
            self.page = 2
            return
        }
        self.page = currentPage + 1
    }
}

enum ListConsultationType: String {
    case ongoing = "on-going"
    case history = "history"
    case cancel = "cancel"
}
