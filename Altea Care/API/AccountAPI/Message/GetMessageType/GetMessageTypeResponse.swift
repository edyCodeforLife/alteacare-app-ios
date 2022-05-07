//
//  GetMessageTypeResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation

struct GetMessageTypeResponse : Codable {
    let status : Bool
    let message : String
    let data : [MessageType]
}

struct MessageType : Codable {
    let id : String
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
    }
}
