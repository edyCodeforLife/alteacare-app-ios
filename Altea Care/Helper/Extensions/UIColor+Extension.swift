//
//  UIColor+Extension.swift
//  Altea Care
//
//  Created by Hedy on 09/03/21.
//

import Foundation
import UIKit

extension UIColor {
    
    class var primary: UIColor {
        return #colorLiteral(red: 0.3803921569, green: 0.7803921569, blue: 0.7098039216, alpha: 1)
    }
    
    class var bottomColor: UIColor {
        return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    class var topColor: UIColor {
        return #colorLiteral(red: 0.9204668999, green: 0.9699953198, blue: 0.986474216, alpha: 1)
    }
    
    class var softblue: UIColor {
        return #colorLiteral(red: 0.8176762462, green: 0.9323497415, blue: 0.9695863128, alpha: 1)
    }
    
    class var darker: UIColor {
        return #colorLiteral(red: 0.7803921569, green: 0.7882352941, blue: 0.8509803922, alpha: 1)
    }
    
    class var info: UIColor {
        return #colorLiteral(red: 0.1725490196, green: 0.3215686275, blue: 0.5450980392, alpha: 1)
    }
    
    class var alteaMainColor: UIColor {
        return #colorLiteral(red: 0.3803921569, green: 0.7803921569, blue: 0.7098039216, alpha: 1)
    }
    class var alteaDark1: UIColor {
        return #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2352941176, alpha: 1)
    }
    class var alteaDark2: UIColor {
        return #colorLiteral(red: 0.4196078431, green: 0.4588235294, blue: 0.5333333333, alpha: 1)
    }
    class var alteaDark3: UIColor {
        return #colorLiteral(red: 0.5607843137, green: 0.5647058824, blue: 0.6509803922, alpha: 1)
    }
    class var alteaDark4: UIColor {
        return #colorLiteral(red: 0.7803921569, green: 0.7882352941, blue: 0.8509803922, alpha: 1)
    }
    class var alteaYellowMain: UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.8, blue: 0.07843137255, alpha: 1)
    }
    class var alteaGreenMain: UIColor {
        return #colorLiteral(red: 0.02352941176, green: 0.7607843137, blue: 0.4392156863, alpha: 1)
    }
    class var alteaRedMain: UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.137254902, blue: 0.137254902, alpha: 1)
    }
    class var alteaBlueMain: UIColor {
        return #colorLiteral(red: 0.2196078431, green: 0.4078431373, blue: 0.6901960784, alpha: 1)
    }
    class var alteaLight1: UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.8980392157, blue: 0.9137254902, alpha: 1)
    }
    class var alteaLight2: UIColor {
        return #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9411764706, alpha: 1)
    }
    class var alteaLight3: UIColor {
        return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9607843137, alpha: 1)
    }
    class var alteaLight4: UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9882352941, alpha: 1)
    }
    class var alteaDarker: UIColor {
        return #colorLiteral(red: 0.2431372549, green: 0.5490196078, blue: 0.7254901961, alpha: 1)
    }
    class var blueLogin: UIColor {
        return #colorLiteral(red: 0.7014063974, green: 0.9322081804, blue: 0.9695224166, alpha: 1)
    }
    class var blueDashboard: UIColor {
        return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    class var innerBorder: UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.8980392157, blue: 0.9137254902, alpha: 1)
    }
    class var error: UIColor {
        return #colorLiteral(red: 1, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    }

    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
