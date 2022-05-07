//
//  VideoCallVC+extension+Network.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/10/21.
//

import Foundation
import UIKit

extension VideoCallVC : NetworkSpeedProviderDelegate{
    func callWhileSpeedChange(networkStatus: NetworkStatus) {
        switch networkStatus {
        case .poor:
            DispatchQueue.main.async {
                self.signalBarImageview.image = UIImage(named: "BadSignalBar")
                self.signalStatusLabel.text = "Bad Signal"
                self.remoteView?.isHidden = true
                self.iconReconnectingImageView.isHidden = false
            }
        case .good:
            DispatchQueue.main.async {
                self.iconReconnectingImageView.isHidden = true
                self.remoteView?.isHidden = false
                self.signalBarImageview.image = UIImage(named: "StrongSignalBar")
                self.signalStatusLabel.text = "Good"
            }
        case .disConnected:
            print("User Disconnected by signal")
            DispatchQueue.main.async {
                print("Bad connection")
                self.disconnect()
                self.signalBarImageview.image = UIImage(named: "BadSignalBar")
                self.reconnectingLabel.text = "Koneksi anda terputus, silahkan coba lagi"
            }

        }
    }
}
