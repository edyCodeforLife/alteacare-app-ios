//
//  ScreeningModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

struct ScreeningModel: Codable {
    let userId: String
    let identity: String
    let roomCode: String
    let token: String
    let mode: ScreeningMode
    
    enum CodingKeys: String, CodingKey {
        case userId, identity, roomCode, token
        case mode = "enable"
    }
}

struct ScreeningMode: Codable {
    let video: Bool
    let voice: Bool
    let chat: Bool
}

enum CallStatus {
    case onWaiting
    case onCalled
    case onError(String)
}
