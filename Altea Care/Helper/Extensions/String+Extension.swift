//
//  String+Extension.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import UIKit

extension String {

    //To check text field or String is blank or not
    func isValidName() -> Bool {
        let inputRegEx = "^[a-zA-Z\\_]{2,25}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    ///To check email is valid format
    func isValidEmail() -> Bool {
        let inputRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,64}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    ///to check phone number is valid format
    func isValidPhone() -> Bool {
        let inputRegEx = "[0-9]{8,16}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    ///to check id card is valid format
    func isValidIdCard() -> Bool {
        let inputRegEx = "[0-9]{13,}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    ///to check character in string is small char
    func isSmallChar() -> Bool {
        let inputRegEx = ".*[a-z]+.*"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    ///to check character in string is capital char
    func isCapitalChar() -> Bool {
        let inputRegEx = ".*[A-Z]+.*"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    ///to check character in string is number inside
    func isNumberInside() -> Bool {
        let inputRegEx = ".*[0-9]+.*"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    ///to check character in string minimal 8 long char
    func isMinimalChar() -> Bool {
        let inputRegEx = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*()-_+={}?>.<,:;~`']{8,}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    ///to check password all criteria
    func isValidPassword() -> Bool {
        let inputRegEx = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*()-_+={}?>.<,:;~`']{8,}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    public func filterPhoneNumber() -> String {
        return String(self.filter {!" ()._-\n\t\r".contains($0)})
    }
    func fileExtensionFromUrl() -> String{
        var ext = ""
        if self.range(of: ".") != nil{
            let fileNameArr = self.split(separator: ".")
            ext = String(fileNameArr.last!).lowercased()
            if ext.contains("?"){
                let newArr = ext.split(separator: "?")
                ext = String(newArr.first!).lowercased()
            }
        }
        return ext
    }
    
    func fileNameFromUrl() -> String{
        if let url = URL(string: self) {
            //            let withoutExt = url.deletingPathExtension()
            let name = url.lastPathComponent
            return name
        }
        return ""
    }
    
    func urlIsImage() -> Bool{
        let ext = self.fileExtensionFromUrl()
        if(ext.contains("jpg") || ext.contains("png") || ext.contains("heic") || ext.contains("jpeg") || ext.contains("tif") || ext.contains("gif")){
            return true
        }
        return false
    }
    
    func formattedDateFromString(fromFormat: String, toFormat: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat

        if let date = inputFormatter.date(from: self) {

          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = toFormat

            return outputFormatter.string(from: date)
        }

        return nil
    }
    
    func dateFormatted() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let str = formatter.date(from: self)
        return str ?? Date()
    }
    
    func dateFormattedUS() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.date(from: self)
        return str ?? Date()
    }
    
    func dateIndonesiaStandard() -> String {
            let formatterDate = DateFormatter()
            formatterDate.dateFormat = "yyyy-MM-dd"
            let dateFormated = formatterDate.date(from: self)
            
            let formatterDateIndonesia = DateFormatter()
            formatterDateIndonesia.dateFormat = "EEEE, d MMMM yyyy"
            formatterDateIndonesia.locale = Locale(identifier: "id_ID")
            let str = formatterDateIndonesia.string(from: dateFormated ?? Date())
            return str
    }
    
    func dateIndonesia() -> String {
            let formatterDate = DateFormatter()
            formatterDate.dateFormat = "yyyy-MM-dd"
            let dateFormated = formatterDate.date(from: self)
            
            let formatterDateIndonesia = DateFormatter()
            formatterDateIndonesia.dateFormat = "dd MMMM yyyy"
            formatterDateIndonesia.locale = Locale(identifier: "id_ID")
            let str = formatterDateIndonesia.string(from: dateFormated ?? Date())
            return str
    }
    
    func toDate(format: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.date(from: format)!
    }
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}

extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    func linkPartOfText(size: CGFloat = 12) -> NSAttributedString {
        var arrString: [String] = []
        let regex = try! NSRegularExpression(pattern: "<link>(.*?)</link>", options: [])
        let text = self as NSString

        regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) { (r, _, _) in
            if let range = r?.range(at: 1) {
                arrString.append(text.substring(with: range))
            }
        }

        var newText = self.replacingOccurrences(of: "<link>", with: "")
        newText = newText.replacingOccurrences(of: "</link>", with: "")

        let defaultFont = UIFont(name: "Inter-Regular", size: size)
        let attributedString = NSMutableAttributedString(string: newText,
                                                         attributes: [NSAttributedString.Key.font: defaultFont!])

        if !arrString.isEmpty {
            for item in arrString {
                let range = (newText as NSString).range(of: item)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
            }
        }
        return attributedString
    }

    func boldPartOfText(size: CGFloat = 12) -> NSAttributedString {
        var arrString: [String] = []
        let regex = try! NSRegularExpression(pattern: "<b>(.*?)</b>", options: [])
        let text = self as NSString

        regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) { (r, _, _) in
            if let range = r?.range(at: 1) {
                arrString.append(text.substring(with: range))
            }
        }

        var newText = self.replacingOccurrences(of: "<b>", with: "")
        newText = newText.replacingOccurrences(of: "</b>", with: "")

        let defaultFont = UIFont(name: "Inter-Regular", size: size)
        let attributedString = NSMutableAttributedString(string: newText,
                                                         attributes: [NSAttributedString.Key.font: defaultFont!])
        let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Inter-Bold", size: size)!]

        if !arrString.isEmpty {
            for item in arrString {
                let range = (newText as NSString).range(of: item)
                attributedString.addAttributes(fontAttribute, range: range)
            }
        }
        return attributedString
    }

    func italicPartOfText(size: CGFloat = 12) -> NSAttributedString {
        var arrString: [String] = []
        let regex = try! NSRegularExpression(pattern: "<i>(.*?)</i>", options: [])
        let text = self as NSString

        regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) { (r, _, _) in
            if let range = r?.range(at: 1) {
                arrString.append(text.substring(with: range))
            }
        }

        var newText = self.replacingOccurrences(of: "<i>", with: "")
        newText = newText.replacingOccurrences(of: "</i>", with: "")

        let defaultFont = UIFont(name: "Inter-Regular", size: size)
        let attributedString = NSMutableAttributedString(string: newText,
                                                         attributes: [NSAttributedString.Key.font: defaultFont!])
        let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Inter-Italic", size: size)!]

        if !arrString.isEmpty {
            for item in arrString {
                let range = (newText as NSString).range(of: item)
                attributedString.addAttributes(fontAttribute, range: range)
            }
        }
        return attributedString
    }

    func underlinePartOfText(size: CGFloat = 12) -> NSAttributedString {
        var arrString: [String] = []
        let regex = try! NSRegularExpression(pattern: "<u>(.*?)</u>", options: [])
        let text = self as NSString

        regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) { (r, _, _) in
            if let range = r?.range(at: 1) {
                arrString.append(text.substring(with: range))
            }
        }

        var newText = self.replacingOccurrences(of: "<u>", with: "")
        newText = newText.replacingOccurrences(of: "</u>", with: "")

        let defaultFont = UIFont(name: "Inter-Regular", size: size)
        let attributedString = NSMutableAttributedString(string: newText,
                                                         attributes: [NSAttributedString.Key.font: defaultFont!])
        let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Inter-Italic", size: size)!]

        if !arrString.isEmpty {
            for item in arrString {
                let range = (newText as NSString).range(of: item)
                attributedString.addAttributes(fontAttribute, range: range)
            }
        }
        return attributedString
    }

}
