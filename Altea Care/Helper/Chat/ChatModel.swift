//
//  ChatModel.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import Foundation
import TwilioChatClient

enum ChatType {
    case inText(message: String)
    case outText(message: String)
    case inImage(message: TCHMessage)
    case outImage(message: TCHMessage)
    case inDocument(message: String)
    case outDocument(message: String)
    
    var type: Int {
        switch self {
        case .inText: return 0
        case .outText: return 1
        case .inImage: return 2
        case .outImage: return 3
        case .inDocument: return 4
        case .outDocument: return 5
        }
    }
}
