//
//  FaqsResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

// MARK: - Welcome
struct FaqsResponse: Codable {
    let status: Bool
    let message: String
    let data: [FaqsData]
}

// MARK: - Datum
struct FaqsData: Codable {
    let faqId, question, answer: String

    enum CodingKeys: String, CodingKey {
        case faqId
        case question, answer
    }
}
