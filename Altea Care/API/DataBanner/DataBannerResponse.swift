//
//  DataBannerResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/07/21.
//

import Foundation

struct DataBannerResponse: Codable {
    let status: Bool
    let message: String
    let data: [BannerData]
}

// MARK: - Datum
struct BannerData: Codable {
    let bannerId, title, datumDescription, deeplinkTypeAndroid: String?
    let deeplinkUrlAndroid, deeplinkTypeIos, deeplinkUrlIos, urlWeb: String?
    let imageMobile, imageDesktop: String?

    enum CodingKeys: String, CodingKey {
        case bannerId
        case title
        case datumDescription
        case deeplinkTypeAndroid
        case deeplinkUrlAndroid
        case deeplinkTypeIos
        case deeplinkUrlIos
        case urlWeb
        case imageMobile
        case imageDesktop
    }
}
