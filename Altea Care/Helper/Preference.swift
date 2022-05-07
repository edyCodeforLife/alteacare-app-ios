//
//  Preference.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

enum PreferenceKey: String {
    case AccessTokenKey
    case AccessRefreshTokenKey
    case FirebaseTokenKey
    case Heroes
    case CreateBooking
    case User
    case UserEmail
    case UserCredentials
    case UserPhone
    case DeviceId
    case DeviceVersion
    case AlreadyInstall
}

struct Preference {
    static func set(value: Any?, forKey key: PreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getString(forKey key: PreferenceKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func removeString(forKey key : PreferenceKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static func getDate(forKey key: PreferenceKey) -> Date? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Date
    }
    
    static func getArray(forKey key: PreferenceKey) -> [Any]? {
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
    
    static func getInt(forKey key: PreferenceKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func getBool(forKey key: PreferenceKey) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func setStruct<T: Codable>(_ value: T?, forKey key: PreferenceKey) {
        let data = try? JSONEncoder().encode(value)
        set(value: data, forKey: key)
    }
    
    static func setStructArray<T: Codable>(_ value: [T], forKey key: PreferenceKey) {
        let data = value.map { try? JSONEncoder().encode($0) }
        set(value: data, forKey: key)
    }
    
    static func structData<T>(_ type: T.Type, forKey key: PreferenceKey) -> T? where T : Decodable {
        guard let encodedData = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    static func structArrayData<T>(_ type: T.Type, forKey key: PreferenceKey) -> [T] where T : Decodable {
        guard let encodedData = UserDefaults.standard.array(forKey: key.rawValue) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}
