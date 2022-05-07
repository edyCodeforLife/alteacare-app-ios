//
//  ListSpecialistResponse.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 11/05/21.
//

import Foundation

class ListSpecialistResponse: Codable {
    let status: Bool
    let message: String
    let data: [ListSpecialistItemModel]
}

struct ListSpecialistItemModel: Codable {
    let specializationId : String?
    let name: String?
    let description : String?
    let isPopular: Bool
    let icon: Icon?
    let subSpecialization: [ListSpecialistItemModel]?
    
    enum CodingKeys: String, CodingKey {
        case specializationId
        case name
        case description
        case isPopular
        case icon
        case subSpecialization
    }
}

struct Icon: Codable {
    let url: String?
    let formats: IconFormats?
    
    enum CodingKeys: String, CodingKey {
        case url
        case formats
    }
}

struct IconFormats: Codable {
    let thumbnail: String?
    let small: String?
    let large: String?
    let medium: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case small
        case large
        case medium
    }
}
