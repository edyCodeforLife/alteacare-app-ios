//
//  ListAddressModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

struct ListAddressModel {
    let status: Bool
    let message: String
    let data: [DetailAddressModel]?
}

struct DetailAddressModel {
    let id, type, street, rtRw: String
    let country: String
    let province: String
    let city: String
    let district: String
    let subDistrict: String
    let latitude, longitude: String
    let idCity : String
    let idProvince : String
    let idDistrict : String
    let idCountry : String
    let idSubDistrict : String
}
