//
//  VideoCallTabBar.swift
//  Altea Care
//
//  Created by Hedy on 22/3/21.
//

import UIKit
import ReplayKit

class VideoCallTabBar: UIView {
    var micTapped: ((Bool) -> Void)?
    var vidTapped: ((Bool) -> Void)?
    var screenSharedTapped: ((Bool) -> Void)?
    var chatTapped: (() -> Void)?
    var moreTapped: (() -> Void)?
    
    var contentView:UIView?
    var tapped = false

    var micTappedFlag = false
    var vidTappedFlag = false
    var screenSharedFlag = false
    
    let controller = RPBroadcastController()
    let recorder = RPScreenRecorder.shared()
    
    @IBOutlet weak var mic: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var shareScreen: UIImageView!
    @IBOutlet weak var messages: UIImageView!
    @IBOutlet weak var other: UIImageView!
    
    @IBOutlet weak var micLabel: ACLabel!
    @IBOutlet weak var camLabel: ACLabel!
    @IBOutlet weak var shareScreenLabel: ACLabel!
    @IBOutlet weak var chatLabel: ACLabel!
    @IBOutlet weak var otherLabel: ACLabel!
    
    @IBOutlet weak var stackMic: UIStackView!
    @IBOutlet weak var stackCam: UIStackView!
    @IBOutlet weak var stackScreen: UIStackView!
    @IBOutlet weak var stackChat: UIStackView!
    @IBOutlet weak var stackOther: UIStackView!
    weak var viewController: UIViewController!
    
    @IBInspectable var nibName:String? = "VideoCallTabBar"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupInit()
    }
        
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
        
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
        
   private func setupInit() {
        micTappedFlag = false
        vidTappedFlag = false
        screenSharedFlag = false
        setupUI()
    }
    
    private func setupUI() {
        addGestures()
        self.micLabel.text = "Mic Aktif"
        self.camLabel.text = "Video Aktif"
        self.shareScreenLabel.text = "Bagikan Layar"
        self.chatLabel.text = "Pesan"
        self.otherLabel.text = "Lainnya"
        self.micLabel.font = .font(size: 8.0, fontType: .normal)
        self.camLabel.font = .font(size: 8.0, fontType: .normal)
        self.shareScreenLabel.font = .font(size: 8.0, fontType: .normal)
        self.chatLabel.font = .font(size: 8.0, fontType: .normal)
        self.otherLabel.font = .font(size: 8.0, fontType: .normal)
    }
    
    private func addGestures() {
        self.stackMic.addTapGestureRecognizer {

            self.micTappedFlag = !self.micTappedFlag
            self.micTapped?(self.micTappedFlag)
            if self.micTappedFlag == true {
                self.mic.image = #imageLiteral(resourceName: "mute")
                self.micLabel.text = "Stop Mic"
            } else {
                self.mic.image = #imageLiteral(resourceName: "mic")
                self.micLabel.text = "Mic Aktif"
            }
        }
        self.stackCam.addTapGestureRecognizer {
            self.vidTappedFlag = !self.vidTappedFlag
            self.vidTapped?(self.vidTappedFlag)
            if self.vidTappedFlag == true {
                self.camera.image = #imageLiteral(resourceName: "turnOffCam")
                self.camLabel.text = "Stop Video"
            } else {
                self.camera.image = #imageLiteral(resourceName: "cam")
                self.camLabel.text = "Video Aktif"
            }
        }
        self.stackScreen.addTapGestureRecognizer {
            self.screenSharedFlag = !self.screenSharedFlag
            self.screenSharedTapped?(self.screenSharedFlag)
            if self.screenSharedFlag == true {
                self.shareScreenLabel.text = "Bagikan Layar"
            } else {
                self.shareScreenLabel.text = "Stop Bagikan"
            }
        }
        self.stackChat.addTapGestureRecognizer {
            self.chatTapped?()
        }
        self.stackOther.addTapGestureRecognizer {
            self.moreTapped?()
        }
    }
    
}

enum TabIconState {
    case active, inactive
}

enum TabItems {
    case microphone, camera, screenSharing, message, otherOptions
    
    var activeIcon: UIImage {
        switch self {
        case .microphone:
            return #imageLiteral(resourceName: "mic")
        case .camera:
            return #imageLiteral(resourceName: "cam")
        case .screenSharing:
            return #imageLiteral(resourceName: "shareScreen")
        case .message:
            return #imageLiteral(resourceName: "noMessage")
        case .otherOptions:
            return #imageLiteral(resourceName: "other")
        }
    }
    
    var inactiveIcon: UIImage {
        switch self {
        case .microphone:
            return #imageLiteral(resourceName: "mute")
        case .camera:
            return #imageLiteral(resourceName: "turnOffCam")
        case .screenSharing:
            return #imageLiteral(resourceName: "shareScreen")
        case .message:
            return #imageLiteral(resourceName: "incomingMessages")
        case .otherOptions:
            return #imageLiteral(resourceName: "other")
        }
    }
}
