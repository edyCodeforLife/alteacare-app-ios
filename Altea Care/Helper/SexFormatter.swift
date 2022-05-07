//
//  SexFormatter.swift
//  Altea Care
//
//  Created by Hedy on 27/04/21.
//

import Foundation

class SexFormatter {
    
    static func formatted(_ value: String) -> String {
        if value == "MALE" {
            return "Laki-Laki"
        }
        return "Perempuan"
    }
}
