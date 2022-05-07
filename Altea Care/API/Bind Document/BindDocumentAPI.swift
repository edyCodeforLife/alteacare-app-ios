//
//  BindDocumentAPI.swift
//  Altea Care
//
//  Created by Hedy on 21/05/21.
//

import Foundation
import RxSwift

protocol BindDocumentAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<BindDocumentResponse>
}
