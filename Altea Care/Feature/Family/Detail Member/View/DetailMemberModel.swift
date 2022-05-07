//
//  DetailMemberModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

struct DetailMemberModel {
    let id : String
    let relationship : String?
    let firstName : String?
    let lastName : String?
    let gender : String?
    let dob: String?
    let age : String?
    let placeOfBirth: String?
    let cityOfBirth: String?
    let citizenship : String?
    let idCardKtp : String?
    let address : String?
    let extPatientId: ExternalPatientID?
}
