//
//  HTTPClient.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import RxSwift

protocol ClientAPI {
    var httpClient: HTTPClient { get }
}

protocol HTTPClient {
    func send<T: Codable>(request apiRequest: HTTPRequest) -> Single<T>
    func send<T: Codable>(request apiRequest: HTTPRequestUpload) -> Single<T>
    func verify() -> Completable
}

protocol HTTPIdentifier {
    var baseUrl: URL { get }
}

class BaseIdentifier: HTTPIdentifier {
    #if DEBUG
//    var baseUrl = URL(string: "https://services.alteacare.com")!
        var baseUrl = URL(string: "https://staging-services.alteacare.com")!
//        var baseUrl = URL(string: "https://dev-services.alteacare.com")!
    #else
        var baseUrl = URL(string: "https://services.alteacare.com")!
//    var baseUrl = URL(string: "https://staging-services.alteacare.com")!
    #endif
}

class SocketIdentifier: HTTPIdentifier {
    #if DEBUG
//    var baseUrl = URL(string: "https://socket.alteacare.com")!
        var baseUrl = URL(string: "https://staging-socket.alteacare.com/")!
//        var baseUrl = URL(string: "https://dev-socket.alteacare.com")!
    #else
        var baseUrl = URL(string: "https://socket.alteacare.com")!
//    var baseUrl = URL(string: "https://staging-socket.alteacare.com/")!
    #endif
}
