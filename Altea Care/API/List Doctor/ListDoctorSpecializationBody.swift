//
//  ListDoctorSpecializationBody.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 16/05/21.
//

import Foundation

struct ListDoctorSpecializationBody: Codable {
    let id: String
    let available_day: String?
    let query: String
    
    enum CodingKeys: String, CodingKey {
        case id = "specialis.id_in"
        case available_day // = "available_day[]"
        case query = "_q"
    }
}

struct DoctorsSpecializationBody: Codable {
    let id: [String]?
    let available_day: String?
    let query: String?
    let limit: String?
    let page: String?
    let idHospital: [String]?
    let priceLt: String?
    let priceGt: String?
    let priceLte: String?
    let priceGte: String?
    let sort: String?
    let isPopular: String?


    enum CodingKeys: String, CodingKey {
        case id = "specialis.id_in"
        case available_day // = "available_day[]"
        case query = "_q"
        case limit = "_limit"
        case page = "_page"
        case idHospital = "hospital.id_in"
        case priceLt = "price_lt"
        case priceGt = "price_gt"
        case priceLte = "price_lte"
        case priceGte = "price_gte"
        case sort = "_sort"
        case isPopular = "is_popular"

    }
}
//id:60d940bfa4b7140031e87193
//specialis.id_in:607d0aaa9be06e0012f2094b
//_q:Dokter Umum
//_limit:500
//_page:1
//hospital.id_in:60c9d8289b299d0012f4ee28
//price_lt:150000
//price_gt:50000
//price_lte:150000
//price_gte:50000
//_sort:price:DESC
//is_popular:YES
//available_day[]:MONDAY
//available_day[]:TUESDAY
//available_day[]:SATURDAY
//available_day[]:SUNDAY
//available_day[]:WEDNESDAY
//available_day[]:THURSDAY
//available_day[]:FRIDAY



