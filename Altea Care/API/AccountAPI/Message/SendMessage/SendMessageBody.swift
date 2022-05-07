//
//  SendMessageBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation

struct SendMessageBody: Codable {
    let message_type, message, name, phone: String
    let email : String
}
