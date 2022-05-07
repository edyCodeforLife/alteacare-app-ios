//
//  ListDoctorModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

struct ListDoctorModel {
    let doctorId: String?
    let experience: String?
    let imagePerson: String?
    let name: String?
    let overview: String?
    let rawPrice: Double
    let formattedPrice: String
    let specialization: String?
    let about: String?
    let imageHospital: String?
    let nameHospital: String?
    let promoPriceFormatted: String
    let promoPriceRaw: Double
    let isAvailable: Bool?
    let isFree:Bool
}
