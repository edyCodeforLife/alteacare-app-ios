//
//  DetailAddressResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

struct DetailAddressResponse: Codable {
    let status: Bool?
    let message: String?
    let version : String?
    let data: Address?
}
