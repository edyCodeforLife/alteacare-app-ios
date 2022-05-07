//
//  SearchAutocompleteModel.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation

public enum search: String {
    case doctor = "Rekomendasi Dokter"
    case symtom = "Gejala dan Diagnosis"
    case specialization = "Rekomendasi Dokter Spesialis"
}

struct SearchEverythingsModel {
    let searchType: search
    let data: [SearchAutocompleteModel]
}


struct MetaSearchModel {
    let totalDoctort: Int
    let totalSymptom: Int
    let totalSpecialization: Int
}

struct SearchAutocompleteModel {
    let type: search
    let id: String?
    let name: String?
    let photo: String?
    let experience: String?
    let specialization: String?
}
