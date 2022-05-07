//
//  HTTPClientImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import RxSwift

class HTTPClientImpl: HTTPClient {
    private let identifier: HTTPIdentifier
    
    init(identifier: HTTPIdentifier) {
        self.identifier = identifier
    }
    
    func send<T: Codable>(request apiRequest: HTTPRequest) -> Single<T> {
        return Single<T>.create { single in
            let request = apiRequest.request(with: self.identifier.baseUrl)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if response != nil {
                    if HTTPReachability.isConnectedToNetwork() {
                        let responseCasting : HTTPURLResponse = response as! HTTPURLResponse
                        if responseCasting.statusCode == 401 {
                            single(.failure(HTTPError.expired))
                        } else {
                            do {
                                self.log(data: data, from: request)
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let model: T = try decoder.decode(T.self, from: data ?? Data())
                                single(.success(model))
                            } catch let error {
                                print("\n=====HTTPResponseError=====")
                                print("RESPONSE FROM \(request.url?.absoluteString ?? self.identifier.baseUrl.absoluteString) => \((error as NSError).userInfo.debugDescription)")
                                print("====================\n")
                                single(.failure(HTTPError.uncodableIssue))
                            }
                        }
                    } else {
                        single(.failure(HTTPError.connectionLost))
                    }
                } else {
                    single(.failure(HTTPError.custom("Opps, Please try again")))
                }
                
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func send<T: Codable>(request apiRequest: HTTPRequestUpload) -> Single<T> {
        return Single<T>.create { single in
            let request = apiRequest.request(with: self.identifier.baseUrl)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
                if HTTPReachability.isConnectedToNetwork() {
                    do {
                        self.log(data: data, from: request)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let model: T = try decoder.decode(T.self, from: data ?? Data())
                        single(.success(model))
                    } catch let error {
                        print("\n=====HTTPResponseError=====")
                        print("RESPONSE FROM \(request.url?.absoluteString ?? self.identifier.baseUrl.absoluteString) => \((error as NSError).userInfo.debugDescription)")
                        print("====================\n")
                        single(.failure(HTTPError.uncodableIssue))
                    }
                } else {
                    single(.failure(HTTPError.connectionLost))
                }
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func log(data: Data?, from urlRequest: URLRequest) {
        if let data = data {
            print("\n=====HTTPResponse=====")
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("RESPONSE FROM \(urlRequest.url?.absoluteString ?? "") \n\(json)")
                }
            } catch let error {
                print("RESPONSE FROM \(urlRequest.url?.absoluteString ?? "") => \(error.localizedDescription)")
            }
            print("====================\n")
        }
    }
    
    func verify() -> Completable {
        return Completable.create { observer in
            guard let refreshToken = Preference.getString(forKey: .AccessRefreshTokenKey) else {
                return Disposables.create()
            }
            let service = GenerateRefreshToken(token: refreshToken)
            let request = service.request(with: BaseIdentifier().baseUrl)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                if HTTPReachability.isConnectedToNetwork() {
                    do {
                        self.log(data: data, from: request)
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let model = try decoder.decode(RefreshTokenResponse.self, from: data ?? Data())
                        if let newToken = model.data?.accessToken {
                            Preference.set(value: newToken, forKey: .AccessTokenKey)
                            Preference.set(value: model.data?.refreshToken, forKey: .AccessRefreshTokenKey)
                            observer(.completed)
                        } else {
                            observer(.error(HTTPError.expired))
                        }
                    } catch let error {
                        print("\n=====HTTPResponseError=====")
                        print("RESPONSE FROM \(request.url?.absoluteString ?? self.identifier.baseUrl.absoluteString) => \((error as NSError).userInfo.debugDescription)")
                        print("====================\n")
                        observer(.error(HTTPError.uncodableIssue))
                    }
                } else {
                    observer(.error(HTTPError.connectionLost))
                }
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
