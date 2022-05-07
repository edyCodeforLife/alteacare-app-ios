//
//  HTTPError.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

enum HTTPError: Error {
    case uncodableIssue
    case connectionLost
    case expired
    case internalError
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .uncodableIssue:
            return "Codable failed, Please try again!"
        case .connectionLost:
            return "You must be connected to the internet"
        case .expired:
            return "Session was expired"
        case .internalError:
            return "Internal Server Error, Please try again!"
        case .custom(let content):
            return content
        }
    }
}

extension HTTPError: Equatable {
    static func ==(lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.uncodableIssue, .uncodableIssue):
            return true
        case (.connectionLost, .connectionLost):
            return true
        case (.expired, .expired):
            return true
        case (let .custom(content1), let .custom(content2)):
            return content1 == content2
        default:
            return false
        }
    }
}

extension Error {
    
    var readableError: String {
        if let errorInNetwork = self as? HTTPError {
            return errorInNetwork.localizedDescription
        } else {
            return self.localizedDescription
        }
    }
}
