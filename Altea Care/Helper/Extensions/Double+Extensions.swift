//
//  Double+Extensions.swift
//  Altea Care
//
//  Created by Hedy on 11/04/21.
//

import Foundation

//MARK: - DOUBLE
extension Double {
    var isInt: Bool {
        return floor(self) == self
    }
    
    var cleanDouble: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.3f", self)
    }
    
    func cleanDouble(_ maxComma: Int) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.\(maxComma)f", self)
    }
    
    func toCurrency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "id_ID")
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = 2
        
        return currencyFormatter.string(from: NSNumber(value: self)) ?? "Rp0"
    }
}
