//
//  NSObject+Extensions.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
