//
//  AddMemberModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

struct AddMemberModel {
    let id : String?
    let relationship : String?
    let firstName : String?
    let lastName : String?
    let gender : String?
    let dob: String?
    let placeOfBirth: String?
    let cityOfBirth: String?
    let citizenship : String?
    let idNumber : String?
    let address : String?
}

struct FamilyRelationModel {
    let status: Bool
    let message: String
    let data: [FamilyRelationData]
}

// MARK: - Datum
struct FamilyRelationData{
    let id : String
    let name : String
    let isDefault : Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isDefault 
    }
}
