//
//  UploadDocumentAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

class UploadDocumentAPIImpl: UploadDocumentAPI {
    
    private class UploadDocument: HTTPRequestUpload {

        var method = HTTPMethod.POST
        var path = "/file/v1/file/upload"
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header : HeaderType
        var media : Media
        var boundary: String
        
        init(media: Media, boundary: String) {
            self.boundary = boundary
            self.media = media
            self.header = HeaderType.formData(boundary: boundary)
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(media: Media, boundary: String) -> Single<UploadDocumentResponse> {
        return httpClient.send(request: UploadDocument(media: media, boundary: boundary) )
    }
}
