//
//  ListHospitalModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 11/10/21.
//

import Foundation

struct ListHospitalModel {
    let hospitalId, name: String
    let phone, address, latitude, longitude: String?
    let image, icon: ImageTerms
    let externalProvider: ExternalProviderTerms
}

struct ImageTerms {
    let sizeFormatted: String
    let mimeType: String
    let url: String
    let formats: FormatsTerms
}

struct FormatsTerms {
    let thumbnail, large, medium, small: String
}

struct ExternalProviderTerms {
    let id, name, code: String
}
