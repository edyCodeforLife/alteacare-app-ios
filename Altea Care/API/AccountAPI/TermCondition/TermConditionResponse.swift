//
//  TermConditionResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

struct TermConditionResponse: Codable {
    let status: Bool
    let message: String
    let data: TermConditionData?
}

// MARK: - DataClass
struct TermConditionData: Codable {
    let blockId, title, type, text: String
}

