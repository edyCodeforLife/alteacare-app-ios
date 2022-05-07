//
//  NotificationService.swift
//  NotificationServices
//
//  Created by Tiara Mahardika on 17/11/21.
//

import UserNotifications
import MORichNotification

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        // 2nd Step
        #if DEBUG
        MORichNotification.setAppGroupID("group.com.mitrakeluarga.AlteaCare.debuging.moengage")
        #else
        MORichNotification.setAppGroupID("group.com.mitrakeluarga.AlteaCare.production.moengage")
//        MORichNotification.setAppGroupID("group.com.mitrakeluarga.AlteaCare.debuging.moengage")
        #endif
        
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // 3rd Step
        MORichNotification.handle(request, withContentHandler: contentHandler)
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
