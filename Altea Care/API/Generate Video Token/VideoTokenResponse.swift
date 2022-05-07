//
//  VideoTokenResponse.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation

struct VideoTokenResponse: Codable {
    let status: Bool
    let message: String
    let data: ScreeningModel?
}
