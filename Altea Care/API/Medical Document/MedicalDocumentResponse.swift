//
//  MedicalDocumentResponse.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation

// MARK: - MedicalDocResponse
//struct MedicalDocumentResponse: Codable {
//    let apiVersion, memoryUsage, elapseTime, lang: String?
//    let code: Int?
//    let error: ErrorConsultation?
//    let data: MedicalDocumentList?
//
//    enum CodingKeys: String, CodingKey {
//        case apiVersion = "api_version"
//        case memoryUsage = "memory_usage"
//        case elapseTime = "elapse_time"
//        case lang, code, error, data
//    }
//}
//
//// MARK: - DataClass
//struct MedicalDocumentList: Codable {
//    let id: Int?
//    let orderNumber: String?
//    let medicalDocument: [MedicalDocument]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case orderNumber = "order_number"
//        case medicalDocument = "medical_document"
//    }
//}
//
//// MARK: - MedicalDocument
//struct MedicalDocument: Codable {
//    let file: String?
//    let filename, size, uploadedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case file, filename, size
//        case uploadedAt = "uploaded_at"
//    }
//}
