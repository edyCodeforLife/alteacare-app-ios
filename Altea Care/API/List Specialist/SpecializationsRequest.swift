//
//  SpecializationsRequest.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 20/12/21.
//

import Foundation

struct SpecializationsRequest: Codable {
    let id: String?
    let _q: String?
    let _limit: String?
    let _page: String?
    let is_popular: String?
}
