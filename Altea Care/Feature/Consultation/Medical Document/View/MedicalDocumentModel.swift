//
//  MedicalDocumentModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

struct MedicalDocumentModel {
    let title: String?
    let content: [MedicalDocumentItem]
}

struct MedicalDocumentItem {
    let id: Int?
    let title: String?
    let size: String?
    let date: String?
    let url: String?
    let isUploadByUser: Bool
}
