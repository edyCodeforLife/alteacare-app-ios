//
//  SymptomResponse.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import Foundation

struct ListSymptomResponse: Codable {
    let status: Bool
    let message: String
    let data: [Symptom]
}

struct Symptom: Codable {
    let symtomId: String
    let name: String
}
