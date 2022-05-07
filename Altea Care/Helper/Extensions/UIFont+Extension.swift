//
//  UIFont+Extension.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import UIKit

extension UIFont {
    
    enum FontLibrary: String {
        case thin = "Inter-Thin"
        case medium = "Inter-Medium"
        case normal = "Inter-Regular"
        case bold = "Inter-Bold"
        case italic = "OpenSans-Italic"
        static func defaultStyle() -> FontLibrary {
            return .normal
        }
    }
    
    static func font(size: CGFloat = 14, fontType: FontLibrary = FontLibrary.defaultStyle()) -> UIFont {
        return UIFont(name: fontType.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
