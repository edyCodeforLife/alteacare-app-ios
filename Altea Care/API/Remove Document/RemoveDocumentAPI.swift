//
//  RemoveDocumentAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol RemoveDocumentAPI: ClientAPI {
    func request(body: [String: Any]) -> Single<RemoveDocumentResponse>
}
