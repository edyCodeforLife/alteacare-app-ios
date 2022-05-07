//
//  Date+Extensions.swift
//  Altea Care
//
//  Created by Hedy on 31/03/21.
//

import Foundation

extension Date{
    
    func getWeekDates() -> (thisWeek:[Date],nextWeek:[Date]) {
        var tuple: (thisWeek:[Date],nextWeek:[Date])
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: arrThisWeek.last!)!)
        }
        tuple = (thisWeek: arrThisWeek,nextWeek: arrNextWeek)
        return tuple
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    public func isSame(_ anotherDate: Date) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        let componentsSelf = calendar.dateComponents([.year, .month, .day], from: self)
        let componentsAnotherDate = calendar.dateComponents([.year, .month, .day], from: anotherDate)
        
        return componentsSelf.year == componentsAnotherDate.year && componentsSelf.month == componentsAnotherDate.month && componentsSelf.day == componentsAnotherDate.day
    }
    
    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toStringDefault() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(from: self)
        return str
    }
    
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    //this func only return today's date to sunday
    func getThisWeek() -> (String,String){
        let arrWeekDates = Date().getWeekDates() // Get dates of Current and Next week.
        let dateFormat = "yyyy-MM-dd" // Date format
        let thisSun = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 1].toDate(format: dateFormat)
        
        return (self.toStringDefault(),thisSun)
    }
    
    func getNextWeek() -> String{
        //get date 7 days from today
        let nextDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        return nextDate!.toStringDefault()
    }
    
    func getNextDay() -> String{
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        return nextDate!.toStringDefault()
    }
    
    func getNextDate() -> Date{
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
    
    func getNextMonth() -> String{
        let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        return nextDate!.toStringDefault()
    }
    
    func getIndonesianFullDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        let str = formatter.string(from: self)
        return str
    }
    
    func getIndonesianDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        let str = formatter.string(from: self)
        return str
    }
    
    func getIndonesianAltDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        let str = formatter.string(from: self)
        return str
    }
    
    func getFullDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let str = formatter.string(from: self)
        return str
    }
    
    func getFullDateStringForAnalytics() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss a"
        formatter.locale = Locale(identifier: "id_ID")
        let str = formatter.string(from: self)
        return str
    }
    
    func getIdDayByAdding(count: Int, date: Date) -> String {
        var dayComponent    = DateComponents()
        dayComponent.day    = count
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: nextDate ?? Date())
    }
    
    func getDayByAdding(count: Int, date: Date) -> String {
        var dayComponent    = DateComponents()
        dayComponent.day    = count
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter.string(from: nextDate ?? Date())
    }
    
    func getDateByAdding(count: Int, date: Date) -> String {
        var dayComponent    = DateComponents()
        dayComponent.day    = count
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter.string(from: nextDate ?? Date())
    }
    
    func dateIndonesia() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "id_ID")
        let str = formatter.string(from: self)
        return str
    }
    
    //    func timeComponent() -> [Int] {
    //        let date = Date()
    //        let cal = Calendar.current
    //        let nowComponents = cal.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: Date())
    //        let component = [date.hour, date.minute, date.second] as [Int]
    //
    //        return component
    //    }
}

class DateTime {
    static func getCurrentDate() -> Date {
        let userCalendar = Calendar.current
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        return currentDate
    }
    
}

extension Calendar {
    //gregorian is counted from sunday and iso8601 from monday
    static let gregorian = Calendar(identifier: .gregorian)
    static let iso8601 = Calendar(identifier: .iso8601)
}

