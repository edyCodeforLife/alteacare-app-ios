//
//  UploadDocumentResponse.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation

struct UploadDocumentResponse: Codable {
    let status: Bool
    let message: String
    let data: UploadDocumentItem?
}

struct UploadDocumentItem: Codable {
    let id: String
    let name: String
    let size : Double
    let url: String
    let formats : IconFormats
}
