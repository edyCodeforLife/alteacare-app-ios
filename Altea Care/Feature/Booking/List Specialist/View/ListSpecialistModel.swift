//
//  ListSpecialistModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

struct ListSpecialistModel {
    let specializationId : String?
    let name: String?
    let description : String?
    let isPopular: Bool
    let iconSmall: String
    let subSpecialization: [ListSpecialistModel]?
    
}
