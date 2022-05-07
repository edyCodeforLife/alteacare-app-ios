//
//  HTTPRequest.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

enum ApiVersion: String {
    case v1 = "v1"
    case v2 = "v2"
    case none = ""
}

enum HeaderType {
    case basic
    case formData(boundary: String)
}

protocol HTTPRequest {
    var method: HTTPMethod { get set }
    var path: String { get }
    var parameters: [String: Any] { get }
    var apiVersion: ApiVersion { get set }
    var authentication: HTTPAuth.tokenType { get  set }
    var header: HeaderType { get set }
}

protocol HTTPBackupRequest {
    var method: HTTPMethod { get set }
    var path: String { get }
    var parameters: [[String: Any]] { get }
    var apiVersion: ApiVersion { get set }
    var authentication: HTTPAuth.tokenType { get  set }
    var header: HeaderType { get set }
}

protocol HTTPRequestUpload {
    var method: HTTPMethod { get set }
    var path: String { get }
    var apiVersion: ApiVersion { get set }
    var authentication: HTTPAuth.tokenType { get  set }
    var header: HeaderType { get set }
    var media: Media { get }
    var boundary: String { get }
    
}

extension HTTPRequest {
    func request(with baseUrl: URL) -> URLRequest {
        let url = "\(baseUrl.absoluteString)\(self.apiVersion.rawValue)\(self.path)"
        let finalUrl = URL(string: url)!
        
        var request = finalUrl.setParameter(parameters: parameters, method: method)
        request.setHeader(type: self.header, authType: self.authentication)
        request.httpMethod = self.method.rawValue
        print("\n=====HTTPRequest=====")
        print("HEADER = \(String(describing: request.allHTTPHeaderFields))")
        if let body = request.httpBody {
            do {
                if let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any] {
                    print("BODY = \(json)")
                }
            } catch let error {
                print(error)
            }
        }
        print("URL = \(String(describing: request.url?.absoluteString))")
        print("METHOD = \(request.httpMethod ?? "NONE")")
        print("====================\n")
        return request
    }
}

extension HTTPBackupRequest {
    func request(with baseUrl: URL) -> URLRequest {
        let url = "\(baseUrl.absoluteString)\(self.apiVersion.rawValue)\(self.path)"
        let finalUrl = URL(string: url)!
        
        var request = finalUrl.setParameters(parameters)
        request.setHeader(type: self.header, authType: self.authentication)
        request.httpMethod = self.method.rawValue
        print("\n=====HTTPRequest=====")
        print("HEADER = \(String(describing: request.allHTTPHeaderFields))")
        if let body = request.httpBody {
            do {
                if let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any] {
                    print("BODY = \(json)")
                }
            } catch let error {
                print(error)
            }
        }
        print("URL = \(String(describing: request.url?.absoluteString))")
        print("METHOD = \(request.httpMethod ?? "NONE")")
        print("====================\n")
        return request
    }
}

extension HTTPRequestUpload {
    func request(with baseUrl: URL) -> URLRequest {
        let url = "\(baseUrl.absoluteString)\(self.apiVersion.rawValue)\(self.path)"
        let finalUrl = URL(string: url)!
        
        var request = finalUrl.setParameter(parameters: [String:Any](), method: method)
        request.setHeader(type: self.header, authType: self.authentication)
        request.httpMethod = self.method.rawValue
        print("\n=====HTTPRequest=====")
        print("HEADER = \(String(describing: request.allHTTPHeaderFields))")
        request.httpBody = createDataBody(with: self.media, boundary: boundary)
        print("URL = \(String(describing: request.url?.absoluteString))")
        print("METHOD = \(request.httpMethod ?? "NONE")")
        print("====================\n")
        return request
    }
    
    func createDataBody(with media: Media?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let media = media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }

}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
