//
//  ChatManager.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import Foundation
import UIKit

class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    private let targetVC = ChatVC()
    
    func show(_ vc: UIViewController, identity: String, accessToken: String, uniqueRoom: String, roomName: String, title: String? = nil) {
        let root = targetVC.wrapInNavigationController()
        root.modalPresentationStyle = .fullScreen
        //Tambahin accessToken = accessToken
        targetVC.accessToken = accessToken
        targetVC.identity = identity
        targetVC.uniqueRoom = uniqueRoom
        targetVC.roomName = roomName
        targetVC.chatTitle = title
        
        vc.present(root, animated: true, completion: nil)
    }
}
