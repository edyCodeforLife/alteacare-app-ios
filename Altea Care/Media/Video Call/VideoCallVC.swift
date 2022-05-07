//
//  VideoCallVC.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import UIKit
import TwilioVideo
import ReplayKit

class VideoCallVC: UIViewController, RPBroadcastActivityViewControllerDelegate, RPBroadcastControllerDelegate, AppScreenSourceDelegate {
    
    var onEndedCall: ((String) -> Void)?
    var accessToken: String?
    var roomName: String?
    var identity: String?
    var receiverNameMa : String?
    var doctor: DoctorCardModel?
    var appointmentId: Int?
    
    var chatManager = ChatService()
    
    // Video SDK components
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteVideoTrack : RemoteVideoTrack?
    var audioDevice: DefaultAudioDevice?
    
    //ShareScreen Needed
    var broadcastController: RPBroadcastController?
    var screenTrack: LocalVideoTrack?
    var shareAudioTrach : LocalAudioTrack?
    let recorder = RPScreenRecorder.shared()
    var videoSource: ReplayKitVideoSource?
    var videoPlayer: AVPlayer?
    var onTapped: (() -> Void)?
    
    var endTime: String?
    var tapped = false
    var speakerTapped = true
    
    var infoTapped = false
    var flipcamTapped = false
    
    var timer : Timer?
    var totalTime = 0
    
    var remoteView: VideoView?
    @IBOutlet weak var shareVideoView: VideoView!
    @IBOutlet weak var callerImgBcg: VideoView!
    @IBOutlet weak var shareReceiverImageView: VideoView!
    
    @IBOutlet weak var dismissContainerButton: UIButton!
    @IBOutlet weak var informationButton: UIImageView!
    @IBOutlet weak var speakerButton: UIImageView!
    @IBOutlet weak var flipCamButton: UIImageView!
    @IBOutlet weak var callingTime: ACLabel!
    @IBOutlet weak var endCallButton: ACButton!
    
    @IBOutlet weak var nameCardContainer: UIView!
    @IBOutlet weak var receiverImage: UIImageView!
    @IBOutlet weak var micReceiver: UIImageView!
    @IBOutlet weak var receiverName: ACLabel!
    
 
    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var micCaller: UIImageView!
    @IBOutlet weak var callerName: ACLabel!
    
    @IBOutlet weak var iconReconnectingImageView: UIImageView!
    @IBOutlet weak var labelCallTime: UILabel!
    @IBOutlet weak var tabBar: VideoCallTabBar!
    
    @IBOutlet weak var containerBadSIgnal: UIView!
    @IBOutlet weak var messageReconnectingLabel: UILabel!
    @IBOutlet weak var reconectingProcessIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var containerSignalBar: ACView!
    @IBOutlet weak var signalBarImageview: UIImageView!
    @IBOutlet weak var signalStatusLabel: UILabel!
    @IBOutlet weak var reconnectingLabel: UILabel!
    @IBOutlet weak var errorIconImage: UIImageView!
    
    //Test Networking
    let test = NetworkSpeedTest()
    
    deinit {
        print("Deinit MessagesViewController")
        NotificationCenter.default.removeObserver(self)
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    static let kBroadcastExtensionBundleId = "com.twilio.ReplayKitExample.BroadcastVideoExtension"
    static let kBroadcastExtensionSetupUiBundleId = "com.twilio.ReplayKitExample.BroadcastVideoExtensionSetupUI"
    
    static let kStartBroadcastButtonTitle = "Start Broadcast"
    static let kInProgressBroadcastButtonTitle = "Broadcasting"
    static let kStopBroadcastButtonTitle = "Stop Broadcast"
    static let kStartConferenceButtonTitle = "Start Conference"
    static let kStopConferenceButtonTitle = "Stop Conference"
    static let kRecordingAvailableInfo = "Ready to share the screen in a Broadcast (extension), or Conference (in-app)."
    static let kRecordingNotAvailableInfo = "ReplayKit is not available at the moment. Another app might be recording, or AirPlay may be in use."
    
    // An application has a much higher memory limit than an extension. You may choose to deliver full sized buffers instead.
    static let kDownscaleBuffers = false
    private var appScreenSource: AppScreenSource?
    
    private var callService: AlteaCallServiceImpl?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.startPreview()
        self.connect()
        self.setupBarButton()
        print("view Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear")
    }
    
    func checkConnection(){
        test.delegate = self
        test.networkSpeedTestStop()
        test.networkSpeedTestStart(UrlForTestSpeed: "https://www.twilio.com/try-twilio")
        self.containerSignalBar.isHidden = false
        hideContainerReconnecting()
    }
    
    private func setupUI() {
        self.startTimer()
        self.micReceiver.image = #imageLiteral(resourceName: "mic")
//        self.receiverName.text = "\(identity ?? "")"
        self.audioDevice = DefaultAudioDevice()
        TwilioVideoSDK.audioDevice = self.audioDevice!
        
        self.endCallButton.set(type: .filled(custom: #colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 1)), title: "Akhiri Panggilan")
        self.endCallButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.test.networkSpeedTestStop()
            self.disconnect()
            self.stopTimer()
            self.dismiss(animated: true) {
                self.onEndedCall?(self.endTime ?? "00:00:00")
            }
        }
        self.tabBar.micTapped = { [weak self] (_) in
            guard let self = self else { return }
            self.toggleMic()
        }
        self.tabBar.vidTapped = { [weak self] (isDisable) in
            guard let self = self else { return }
            self.toggleVideo()
        }
        self.tabBar.screenSharedTapped = { [weak self] (_) in
            guard let self = self else { return }
            self.toogleShareScreen()
        }
        self.tabBar.chatTapped = { [weak self] in
            guard let self = self else { return }
            
            ChatManager.shared.show(self, identity: self.identity ?? "", accessToken: self.accessToken ?? "", uniqueRoom: self.roomName ?? "", roomName: self.roomName ?? "")
            self.defaultAnalyticsService.trackUserAttribute(self.doctor?.name, key: AnalyticsCustomAttributes.lastDoctorChatName.rawValue)
        }
    }
    
    private func setupBarButton() {
        self.informationButton.addTapGestureRecognizer {
            self.tapped = !self.tapped
            self.onTapped?()
            self.showToast(message: "\(self.roomName ?? "")")
        }
        self.speakerButton.addTapGestureRecognizer {
            self.onTapped?()
            
            if self.speakerTapped == true {
                self.speakerTapped = false
                self.toggleLoudspeaker(isEnabled: true)
                self.speakerButton.image = UIImage(named: "volume")
            } else {
                self.speakerTapped = true
                self.toggleLoudspeaker(isEnabled: false)
                if #available(iOS 13.0, *) {
                    self.speakerButton.image = UIImage(systemName: "volume.2.fill")
                    self.speakerButton.tintColor = UIColor.white
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        self.flipCamButton.addTapGestureRecognizer {
            self.onTapped?()
            
            var newDevice: AVCaptureDevice?
            
            if let camera = self.camera, let captureDevice = camera.device {
                if captureDevice.position == .front {
                    newDevice = CameraSource.captureDevice(position: .back)
                } else {
                    newDevice = CameraSource.captureDevice(position: .front)
                }
                
                if let newDevice = newDevice {
                    camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                        if let error = error {
                            self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                        } else {
                            self.callerImgBcg.shouldMirror = (captureDevice.position == .front)
                        }
                    }
                }
            }
        }
    }
    
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        
        self.view.insertSubview(self.remoteView!, at: 0)
        
        // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `VideoView` programmatically.
        self.remoteView!.contentMode = .scaleAspectFit;
        
        let centerX = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView!,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.view,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.view.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView!,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.view,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.view.addConstraint(height)
    }
    
    @objc func tapBroadcastPickeriOS13(sender: UIButton) {
        let message = "ReplayKit broadcasts can not be started using the broadcast picker on iOS 13.0. Please upgrade to iOS 13.1+, or start a broadcast from the screen recording widget in control center instead."
        let alertController = UIAlertController(title: "Start Broadcast", message: message, preferredStyle: .actionSheet)
        
        let settingsButton = UIAlertAction(title: "Launch Settings App", style: .default, handler: { (action) -> Void in
            // Launch the settings app, with control center if possible.
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { (success) in
            }
        })
        
        alertController.addAction(settingsButton)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sender
            alertController.popoverPresentationController?.sourceRect = sender.bounds
        } else {
            // Adding the cancel action
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            })
            alertController.addAction(cancelButton)
        }
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func connect() {
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
        guard let accessToken = self.accessToken else { return }
        
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = VideoSettings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = VideoSettings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = VideoSettings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // Use the preferred signaling region
            if let signalingRegion = VideoSettings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = self.roomName ?? ""
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        logMessage(messageText: "room conenct twilio\(String(describing: room))")
//        BasicAlert.shared.showLoading(self.view)
        
        self.connectToInternalSocket()
    }
    
    private func connectToInternalSocket() {
        //Constructor
        let param: [String: Any] = ["method": self.doctor == nil ? "IN_ROOM_MA" : "IN_ROOM_SP", "appointmentId": appointmentId ?? 0]
        self.callService = AlteaCallServiceImpl(url: SocketIdentifier().baseUrl, param: param)

        //Configure Callback/Listener
        self.callService?.callback = self
        self.callService?.setListener(events: ["connect_error", "socket_error"])
        
        self.callService?.connect()
    }
    
    private func disconnectInternalSocket() {
        self.callService?.disconnect()
    }
    
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        
    }
    
    private func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        print(self.totalTime)
        self.labelCallTime.text = self.timeFormatted(self.totalTime)
        self.endTime =  self.timeFormatted(self.totalTime)
        
        if totalTime >= 0 {
            totalTime += 1
        } else {
            if self.timer != nil{
                self.stopTimer()
                self.timer = nil
            }
        }
    }
    
    private func stopTimer(){
//        self.endTime = totalTime
        self.timer?.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func disconnect() {
        if self.room != nil {
            self.room!.disconnect()
            self.stopTimer()
//            test.networkSpeedTestStop()
            logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
        }
        self.disconnectInternalSocket()
        self.room = nil
        self.camera = nil
        self.localVideoTrack = nil
        self.localAudioTrack = nil
        self.remoteParticipant = nil
        self.remoteVideoTrack = nil
        self.audioDevice = nil
    }
    
    func toggleMic() {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
        }
    }
    
    func toggleVideo() {
        if (self.localVideoTrack != nil) {
            self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled)!
        }
    }
    
    func toggleLoudspeaker(isEnabled: Bool){
        if (self.audioDevice != nil) {
            self.audioDevice?.isEnabled = !(self.audioDevice?.isEnabled)!
        }
    }
    
    private func stopConference(error: Error?) {
        shareVideoView.isHidden = true
        appScreenSource?.stopCapture { captureError in
            if let captureError = captureError {
                print("Screen capture stop error: ", captureError as Any)
                return
            }
            self.room?.localParticipant?.unpublishVideoTrack(self.screenTrack!)
            self.room?.localParticipant?.publishVideoTrack(self.localVideoTrack!)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            
        }
    }
    
    private func startConference() {
        // Start recording the screen.
        let options = AppScreenSourceOptions() { builder in
            builder.screenContent = VideoCallVC.kDownscaleBuffers ? .video : .default
        }
        
        appScreenSource = AppScreenSource(options: options, delegate: self)
        
        screenTrack = LocalVideoTrack(source: appScreenSource!,
                                      enabled: true,
                                      name: "Screen")
        shareVideoView.isHidden = false
        screenTrack?.addRenderer(self.shareVideoView)
        
        appScreenSource?.startCapture { error in
            if error != nil {
                print("Screen capture error: ", error as Any)
            } else {
                self.room?.localParticipant?.publishVideoTrack(self.screenTrack!)
                self.room?.localParticipant?.unpublishVideoTrack(self.localVideoTrack!)
            }
        }
    }
    
    
    func toogleShareScreen(){
        if self.screenTrack != nil {
            stopConference(error: nil)
        } else {
            startConference()
        }
    }
    
    func stopBroadcast() {
        broadcastController!.finishBroadcast { error in
            if error == nil {
                print("Broadcast ended")
                self.tabBar.shareScreenLabel.text = "Share Screen"
            }
        }
    }
    
    // MARK:- Private
    func startPreview() {
        
        if PlatformUtils.isSimulator {
            return
        }
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
            }
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.callerImgBcg)
            logMessage(messageText: "Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(flipCamera))
                self.callerImgBcg.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.callerImgBcg.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.callerImgBcg.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }

    
    func prepareLocalMedia() {
        // We will share local audio and video when we connect to the Room.
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    ///Func not called in anywhere?
    func moveLocalVideoToSecondView(){
        if remoteView?.isHidden == true {
            shareReceiverImageView.isHidden = false
            localVideoTrack?.removeRenderer(self.remoteView!)
            localVideoTrack?.addRenderer(self.shareReceiverImageView!)
        }
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
                print("video mana : \(subscribedVideoTrack)")
                self.containerBadSIgnal.isHidden = true
                self.messageReconnectingLabel.isHidden = true
                self.iconReconnectingImageView.isHidden = true
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
    func hideContainerReconnecting(){
//        remoteView?.isHidden = false
        containerBadSIgnal.isHidden = true
        messageReconnectingLabel.isHidden = true
        reconectingProcessIndicator.isHidden = true
        iconReconnectingImageView.isHidden = true
        reconectingProcessIndicator.stopAnimating()
    }
    
    func showContainerReconnecting(){
//        remoteView?.isHidden = true
//        iconReconnectingImageView.isHidden = false
        containerBadSIgnal.isHidden = false
        messageReconnectingLabel.isHidden = false
        messageReconnectingLabel.text = "Koneksi dengan Dashboard terputus. Sedang menghubungkan kembali"
        messageReconnectingLabel.textColor = .white
        errorIconImage.isHidden = true
        reconectingProcessIndicator.isHidden = false
        reconectingProcessIndicator.startAnimating()
    }
    
    func setupViewDashboardReconnecting(){
        showContainerReconnecting()
    }
    
    func setupViewLocalReconnecting(){
        showContainerReconnecting()
        self.remoteView?.isHidden = true
    }
    
    func setupViewLocalReconnected(){
        hideContainerReconnecting()
        self.remoteView?.isHidden = false
        self.reconectingProcessIndicator.stopAnimating()
    }
    
    func setupViewParticipantDidDisconnected(){
        self.reconectingProcessIndicator.stopAnimating()
        self.iconReconnectingImageView.isHidden = false
        self.containerBadSIgnal.isHidden = false
        self.containerSignalBar.isHidden = false
        self.reconnectingLabel.text = ""
        self.messageReconnectingLabel.isHidden = false
        self.messageReconnectingLabel.text = "Koneksi dengan Dashboard terputus, panggilan berakhir silahkan tekan 'Akhiri Panggilan'"
        self.messageReconnectingLabel.textColor = .error
        self.errorIconImage.isHidden = false
    }
    
    @IBAction func buttonDissmissTapped(_ sender: Any) {
        self.containerBadSIgnal.isHidden = true
        self.messageReconnectingLabel.isHidden = true
        self.iconReconnectingImageView.isHidden = true
    }
}

// MARK:- RoomDelegate
extension VideoCallVC : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        receiverImage.isHidden = true
        self.containerBadSIgnal.isHidden = true
        self.messageReconnectingLabel.isHidden = true
        self.iconReconnectingImageView.isHidden = true
        self.containerSignalBar.isHidden = false
        self.remoteView?.isHidden = false
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
        
        print("Room did connect, room : \(room.state)")
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        if error?.readableError.contains("20104") != nil || ((error?.readableError.contains("53002")) != nil) || ((error?.readableError.contains("53405")) != nil) || ((error?.readableError.contains("53000")) != nil) {

            self.disconnect()
//            self.test.networkSpeedTestStop()
            self.reconectingProcessIndicator.stopAnimating()
            self.reconnectingLabel
                .isHidden = false
            self.containerBadSIgnal.isHidden = false
            self.messageReconnectingLabel.isHidden = false
            self.messageReconnectingLabel.text = "Koneksi Anda dengan Medical Advisor terputus, panggilan berakhir silahkan tekan ‘Akhiri Panggilan’"
            self.messageReconnectingLabel.textColor = .error
            self.errorIconImage.isHidden = false
            self.reconnectingLabel.text = "Panggilan Anda Terputus"
            self.iconReconnectingImageView.isHidden = false
            self.chatManager.leaveChannel()
            self.room = nil
        }
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        print("roomDidFailConect error : \(String(describing: error))")
        /// Show disconnect view, Failed to Connect to View Call Room
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.roomDidDisconnect(room: room, error: error)
        BasicAlert.shared.showError(self.view, title: "Error", message: error.readableError)
        
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        print("roomIsReconnecting error code : \(error.readableError)")
        self.showContainerReconnecting()
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
        
        if error.readableError.contains("53001") || error.readableError.contains("53004") {
            messageReconnectingLabel.text = "Koneksi sedang tidak stabil. Mencoba menghubungkan kembali"
            self.messageReconnectingLabel.textColor = .white
            self.errorIconImage.isHidden = true
            self.setupViewLocalReconnecting()
        }
        
    }
    
    //MARK: - Handle this reconnect
    func roomDidReconnect(room: Room) {
        self.setupViewLocalReconnected()
        self.hideContainerReconnecting()
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        print("participat DidConnect : \(participant)")
        participant.delegate = self
        self.receiverName.text = participant.identity
        self.remoteView?.isHidden = false
        self.containerBadSIgnal.isHidden = true
        self.messageReconnectingLabel.isHidden = true
        self.iconReconnectingImageView.isHidden = true
        self.checkConnection()
        self.containerSignalBar.isHidden = false
        self.reconectingProcessIndicator.stopAnimating()
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print("participant did disconnect")
        self.setupViewParticipantDidDisconnected()
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        
//         Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
    
    func participantIsReconnecting(room: Room, participant: RemoteParticipant) {
        print("participant is reconnecting")
        self.setupViewDashboardReconnecting()
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) isReconnecting")
    }
    
    func participantDidReconnect(room: Room, participant: RemoteParticipant) {
        print("participant did reconnect")
        self.remoteView?.isHidden = false
        self.iconReconnectingImageView.isHidden = true
        self.receiverName.text = participant.identity
        self.reconectingProcessIndicator.stopAnimating()
        self.containerBadSIgnal.isHidden = true
        self.containerSignalBar.isHidden = false
    }
}

// MARK:- RemoteParticipantDelegate
extension VideoCallVC : RemoteParticipantDelegate {
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        print("remote participant sharescrreen video")
        print("remote sharescreen : \(publication.isTrackSubscribed), dan : \(publication.isTrackEnabled)")
        
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
        
        for _ in participant.remoteVideoTracks {
            print("remote room apa : \(participant.remoteVideoTracks)")
        }
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
        self.receiverNameMa = "\(participant.identity)"
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        print("remoteParticipantDidUnpublishVideoTrack")
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        self.micReceiver.image = UIImage(named: "mic")
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        self.micReceiver.image = UIImage(named: "mute")
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        //start subscribe remote share screen
        print("subscribe video track remote participant")
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        remoteView?.isHidden = false
        shareReceiverImageView.isHidden = true
        self.iconReconnectingImageView.isHidden = true
        self.reconnectingLabel.isHidden = true
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print("didUnsubscribeFromVideoTrack")
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        remoteView?.isHidden = false
        shareReceiverImageView.isHidden = true
        self.iconReconnectingImageView.isHidden = false
        self.reconnectingLabel.isHidden = false
        if self.remoteParticipant == participant {
        cleanupRemoteParticipant()
    
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        print("subscribe audio track remote participant")
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        print("unsubscribe audio track remote participant")
       
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("remote participant enable video track")
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
        receiverImage.isHidden = true
        remoteView?.isHidden = false
        self.iconReconnectingImageView.isHidden = true
        self.shareVideoView.isHidden = true
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("remote participant disable video track")
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
        self.receiverImage.isHidden = false
        remoteView?.isHidden = true
        self.iconReconnectingImageView.isHidden = false
        self.shareVideoView.isHidden = true
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("remote participant enable audio track")
        self.micReceiver.image = #imageLiteral(resourceName: "mic")
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("remote participant disable audio track")
        self.micReceiver.image = #imageLiteral(resourceName: "mute")
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print("fail subscribe audio track from participant")
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("fail to subcribe video track from participant")
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension VideoCallVC : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension VideoCallVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}

struct VideoCallModel {
    let callerImage: UIImage?
    let callerName: String?
    let callerMicState: Bool
    let receiverImage: UIImage?
    let receiverName: String?
    let receiverMicState: Bool
    //    let information: String?
    //    let speaker: Bool
    //    let flipCamera: Bool
    let duration: String?
}

extension VideoCallVC: AlteaCallService {
    
    func onConnected() {
        print("onConnected")
    }
    
    func onDisconneted() {
        print("onDisconneted")
    }
    
    func didReceive(eventName: String, data: [Any]) {
        print("didReceive")
    }
}

