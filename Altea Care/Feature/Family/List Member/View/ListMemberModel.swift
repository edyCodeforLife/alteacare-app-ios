//
//  ListMemberModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation


struct ListMemberModel {
    let isFullyLoaded: Bool
    let model: [MemberModel]?
}

struct MemberModel {
    let idMember: String
    let name: String
    let role: String
    let imageUser : String
    let age: String
    let gender : String
    let birthDate : String
    let isMainProfile: Bool
    let email: String?
    let phone: String?
}
