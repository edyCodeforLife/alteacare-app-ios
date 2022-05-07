//
//  TermRefundCancelResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/06/21.
//

import Foundation

struct TermRefundCancelResponse : Codable {
    
    let status: Bool
    let message: String
    let data: TermRefundData?
}

// MARK: - DataClass
struct TermRefundData: Codable {
    let blockId, title, type, text: String
    
    enum CodingKeys: String, CodingKey {
        case blockId
        case title, type, text
    }
}
