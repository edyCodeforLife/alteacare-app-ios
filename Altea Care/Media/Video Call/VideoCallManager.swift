//
//  VideoCallManager.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import Foundation
import UIKit

class VideoCallManager {
    
    var onEndedCall: ((String) -> Void)?
    
    static let shared = VideoCallManager()
    private init() { }
    private var targetVC: VideoCallVC? = nil
    
    func show(_ vc: UIViewController, accessToken: String, identity: String, roomName: String, doctor: DoctorCardModel?, appointmentId: Int, completion: @escaping ((String) -> Void?)) {
        self.targetVC = VideoCallVC()
        guard let targetVC = targetVC else {
            return
        }
        let root = targetVC.wrapInNavigationController()
        targetVC.navigationController?.setNavigationBarHidden(true, animated: true)
        targetVC.accessToken = accessToken
        targetVC.roomName = roomName
        targetVC.identity = identity
        targetVC.doctor = doctor
        targetVC.appointmentId = appointmentId
        targetVC.onEndedCall = { [weak self] (endTime) in
            guard let self = self else { return }
            completion(endTime)
            self.targetVC = nil
        }
        root.modalPresentationStyle = .fullScreen
        vc.present(root, animated: true, completion: nil)
    }
}
