//
//  InformationCenterResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/08/21.
//

import Foundation

// MARK: - InformationCenter
struct InformationCenterResponse: Codable {
    let status: Bool
    let message: String
    let data: InformationData?
}

// MARK: - DataClass
struct InformationData: Codable {
    let contentId, title, type: String
    let content: ContentData

    enum CodingKeys: String, CodingKey {
        case contentId
        case title, type, content
    }
}

// MARK: - Content
struct ContentData: Codable {
    let email, phone: String
}
