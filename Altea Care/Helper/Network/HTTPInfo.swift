//
//  HTTPInfo.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit

extension URL {
    func setParameter(parameters: [String: Any], method: HTTPMethod) -> URLRequest {
        switch method {
        case .GET:
            var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
            var queryItems: [URLQueryItem] = []
            for key in parameters.keys {
                queryItems.append(URLQueryItem(name: key, value: "\(parameters[key]!)"))
            }
            urlComponents.queryItems = queryItems
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return URLRequest(url: urlComponents.url!)
        default:
            var request = URLRequest(url: self)
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            return request
        }
    }
    
    func setParameters(_ parameters: [[String: Any]]) -> URLRequest {
        var request = URLRequest(url: self)
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        return request
    }
}

extension URLRequest {
    mutating func setHeader(type: HeaderType, authType: HTTPAuth.tokenType) {
        switch type {
        case .basic:
            self.setDefaultHeader(type: authType)
        case .formData(let boundary):
            self.setFormDataHeader(type: authType, boundary: boundary)
        }
    }
    
    mutating func setDefaultHeader(type: HTTPAuth.tokenType) {
        self.setAuthHeader(type: type)
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "accept")
    }
    
    mutating func setFormDataHeader(type: HTTPAuth.tokenType, boundary: String) {
        self.setAuthHeader(type: type)
        self.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "accept")
    }
}

extension URLRequest {
    private mutating func setAuthHeader(type: HTTPAuth.tokenType) {
        self.setVersionHeader()
        switch type {
        case .basic:
            self.setBasicAuth()
        case .bearer:
            self.setBearerAuth()
        }
    }
    
    private mutating func setVersionHeader(){
        let kVersion = "CFBundleShortVersionString"
        let kBuildNumber = "CFBundleVersion"
        
        let nameDevice = UIDevice.modelName
        let versionIos = UIDevice.current.systemVersion
        
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?[kVersion] as? String
        let build = dictionary?[kBuildNumber] as? String
        let deviceId = Preference.getString(forKey: .DeviceId)
        
        self.addValue("IOS", forHTTPHeaderField: "x-app-platform")
        self.addValue(build ?? "", forHTTPHeaderField: "x-app-version-code")
        self.addValue(version ?? "", forHTTPHeaderField: "x-app-version")
        self.addValue(deviceId ?? "", forHTTPHeaderField: "x-app-device-id")
        self.addValue(nameDevice, forHTTPHeaderField: "x-app-device-name")
        self.addValue(versionIos, forHTTPHeaderField: "x-app-device-version")
    }
    
    private mutating func setBasicAuth() {
        //        self.addValue(AMHTTPAuth.shared.basic, forHTTPHeaderField: "Authorization")
        return
    }
    
    private mutating func setBearerAuth() {
        if let bearerToken = HTTPAuth.shared.bearerToken {
            self.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        } else {
            self.addValue("", forHTTPHeaderField: "Authorization")
        }
    }
}

extension Encodable {
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    public var dictionaryWithConvert: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func converted() -> [[String: Any]] {
        do {
            let data = try JSONEncoder().encode(self)
            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return result as? [[String: Any]] ?? []
        } catch let error {
            print("converted() = \(error.localizedDescription)")
            return []
        }
    }
}
