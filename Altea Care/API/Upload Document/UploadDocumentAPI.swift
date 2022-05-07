//
//  UploadDocumentAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol UploadDocumentAPI: ClientAPI {
    func request(media: Media, boundary: String) -> Single<UploadDocumentResponse>
}
