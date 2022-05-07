//
//  BannerModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/07/21.
//

import Foundation

struct BannerModel{
    let imageUrl : String?
    let deeplinkUrlIos : String?
    let deeplinkIosType : String?
}

enum BannerCategory: String {
    case telemedicine = "TELEMEDICINE"
    case pharmacy = "PHARMACY"
}
