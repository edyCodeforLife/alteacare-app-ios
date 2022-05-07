//
//  Colors.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 19/03/21.
//

import Foundation
import UIKit

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 214.0 / 255.0, green: 237.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
    
    // Yellow
    static let cYellowBorder = UIColor(red: 0.89, green: 0.72, blue: 0.24, alpha: 1.00)
    static let cYellowBackground = UIColor(red: 0.93, green: 0.78, blue: 0.33, alpha: 1.00)
    static let cYellowish = UIColor(red:0.98, green:0.79, blue:0.09, alpha:1.0)
    static let cYellowText = UIColor(red: 0.94, green: 0.82, blue: 0.00, alpha: 1.00)
    
    // Green
    static let cGreenLabel = UIColor(red: 0.42, green: 0.77, blue: 0.22, alpha: 1.00)
    static let cGreenGradient = UIColor(red: 0.11, green: 0.59, blue: 0.42, alpha: 1.00)
    static let cGreenBorder = UIColor(red: 0.51, green: 0.75, blue: 0.16, alpha: 1.00)
    static let cGreenBackground = UIColor(red: 0.63, green: 0.80, blue: 0.40, alpha: 1.00)
    static let cGreenGrey = UIColor(red: 0.49, green: 0.47, blue: 0.52, alpha: 1.00)
    static let cGreen = UIColor(red:0.34, green:0.67, blue:0.18, alpha:1.0)
    static let cGreenish = UIColor(red:0.82, green:0.85, blue:0.81, alpha:1.0)
    static let cGreenee = UIColor(red:0.18, green:0.84, blue:0.43, alpha:1.0)
}
