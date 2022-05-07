//
//  Webview.swift
//  Altea Care
//
//  Created by Hedy on 05/11/20.
//

import Foundation
import WebKit

enum WebviewResourceType {
    case file(url: String)
    case web(url: String)
    case contentHTML(url: String)
    
    func loadResourceFile(_ url: String) -> URL {
        let path = Bundle.main.url(forResource: url, withExtension: "html")!
        return path
    }
    
    func loadResourceWeb(_ url: String) -> URLRequest {
        let myURL = URL(string: url)!
        return URLRequest(url: myURL)
    }
    
    var label: String {
        switch self {
        case .contentHTML(let url):
            return url
        case .file(let url):
            return url
        case .web(let url):
            return url
        }
    }
}

extension WKWebView {
    func load(_ resourceType: WebviewResourceType) {
        switch resourceType {
        case .file(let url):
            let request = resourceType.loadResourceFile(url)
            self.loadFileURL(request, allowingReadAccessTo: request.deletingLastPathComponent())
        case .web(let url):
            let request = resourceType.loadResourceWeb(url)
            self.load(request)
        case .contentHTML(let url):
            self.loadHTMLString(url, baseURL: nil)
        }
    }
}
