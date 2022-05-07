//
//  DocumentManager.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import Foundation
import UIKit

class DocumentManager {
    
    static let shared = DocumentManager()
    private init() { }
    private let targetVC = DocumentViewerVC()
    
    func show(_ vc: UIViewController, resource: WebviewResourceType, title: String?) {
        let root = targetVC.wrapInNavigationController()
        root.modalPresentationStyle = .fullScreen
        targetVC.resourceType = resource
        targetVC.documentTitle = title
        vc.present(root, animated: true, completion: nil)
    }
}
