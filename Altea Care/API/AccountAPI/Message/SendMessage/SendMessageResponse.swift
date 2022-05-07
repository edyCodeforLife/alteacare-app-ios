//
//  SendMessageResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation

struct SendMessageResponse : Codable{
    let status: Bool
    let message: String
    let data : String
}

