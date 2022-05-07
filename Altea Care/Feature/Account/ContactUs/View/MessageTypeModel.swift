//
//  MessageTypeModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 27/07/21.
//

import Foundation

struct MessageTypeModel {
    let status : Bool
    let message : String
    let data : [MessageTypeData]?
}

struct MessageTypeData  {
    let id : String
    let name : String

}
