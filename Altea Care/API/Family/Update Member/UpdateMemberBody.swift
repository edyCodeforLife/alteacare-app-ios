//
//  UpdateMemberBody.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

struct UpdateMemberBody: Codable {
    let familyRelationType, firstName: String?
    let lastName, gender, birthDate, birthCountry: String?
    let birthPlace, nationality, cardID, addressID: String?

    enum CodingKeys: String, CodingKey {
        case familyRelationType = "family_relation_type"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case birthDate = "birth_date"
        case birthCountry = "birth_country"
        case birthPlace = "birth_place"
        case nationality
        case cardID = "card_id"
        case addressID = "address_id"
    }
}
