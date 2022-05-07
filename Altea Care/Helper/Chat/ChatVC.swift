//
//  ChatVC.swift
//  Altea Care
//
//  Created by Hedy on 13/03/21.
//
import UIKit
import PanModal

class ChatVC: UIViewController, ChatView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintBottomContainerChat: NSLayoutConstraint!
    @IBOutlet weak var constraitHeightContainerChat: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageView: ACView!
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var sendView: ACView!
    @IBOutlet weak var messageTV: GrowingTextView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var onClosed: (() -> Void)?
    internal var content = [ChatType]()
    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    var accessToken: String!
    var identity: String!
    var uniqueRoom: String!
    var roomName: String!
    var chatTitle: String? = nil
    
    // Convenience class to manage interactions with Twilio Chat
    var chatManager = ChatService()
    
    var imageSelected : UIImage!
    var documentSelected : NSURL!
    
    lazy var previewItem = NSURL()
    //add setup for camera
    lazy var imagePickerHandler = ImagePickerHandler(sourceType: .photoLibrary)
    lazy var filePickerHandler = FilePickerHandler()
    private lazy var attachPicker: AttachPickerVC = {
        let vc = AttachPickerVC()
        vc.delegate = self
        return vc
    }()
    
    let prepareChatRelay = 5
    
    var imageChat : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupView()
        chatManager.delegate = self
        setupRoom()
        login()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        setupRoom()
        //        login()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //When close or dismiss from chat, clear all history chat on user side
        //Close
        //        content.removeAll()
        //        chatManager.shutdown()
    }
    
    func bindViewModel() {}
    
    // MARK: - View Setup
    private func setupNavigation() {
        self.setTextNavigation(title: self.chatTitle ?? "Chat", navigator: .close)
    }
    
    func showProgressBar(){
        self.progressView.setProgress(Float(10000), animated: true)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNIB(with: RightTextCell.self)
        tableView.registerNIB(with: LeftTextCell.self)
        tableView.registerNIB(with: RightImageCell.self)
        tableView.registerNIB(with: LeftImageCell.self)
        tableView.registerNIB(with: RightFileCell.self)
        tableView.registerNIB(with: LeftFileCell.self)
    }
    
    private func setupView(){
        guard let italicsFont = UIFont(name: "OpenSans-Italic", size: 14.0) else {return}
        let attr = NSMutableAttributedString(string: "Ketik pesan disini...", attributes: [NSAttributedString.Key.font : italicsFont])
        messageTV.attributedPlaceholder = attr
        messageTV.delegate = self
        self.setupHideKeyboardWhenTappedAround()
    }
    
    private func setupKeyboard(){
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Keyboard Setup
    @objc func keyboardWillHide(_ notification: Notification){
        let info: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        
        let animateDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        self.tableViewConstraint.constant = 0
        self.camButton.isHidden = false
        self.sendView.isHidden = true
        UIView.animate(withDuration: animateDuration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardChange(_ notification: Notification){
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight: CGFloat = keyboardSize.height
        let animateDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        tableView.scroll(to: .bottom, animated: true)
        self.camButton.isHidden = true
        self.sendView.isHidden = false
        self.tableViewConstraint.constant = 0 + keyboardHeight - 32
        UIView.animate(withDuration: animateDuration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Button Action
    @IBAction func attachmentTapped(_ sender: Any) {
        view.endEditing(true)
        presentPanModal(attachPicker)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        view.endEditing(true)
        camSelected()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        guard let text = self.messageTV.text else { return }
        if self.messageTV.text.isNotEmpty {
            chatManager.sendMessage(text, completion: { (result, _) in
                if result.isSuccessful() {
                    self.messageTV.text = ""
                    //                    self.messageTV.text = ""
                } else {
                    self.displayErrorMessage("Unable to send message")
                }
            })
        }
    }
    
    // MARK: Setup Room
    func setupRoom() {
        chatManager.uniqueChannelName = self.uniqueRoom
        chatManager.friendlyChannelName = self.roomName
    }
    
    // MARK: Login
    func login() {
        chatManager.login(self.identity, accessToken: self.accessToken, uniqueRoom: self.uniqueRoom, roomName: self.roomName) { (success) in
            DispatchQueue.main.async {
                if success {
                    print("Logged in as \"\(self.identity ?? "NULL")\"")
                } else {
                    self.navigationItem.prompt = "Unable to login"
                    let msg = "Unable to login - check the token URL in ChatConstants.swift"
                    self.displayErrorMessage(msg)
                }
            }
        }
    }
    
    private func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: ChatService
extension ChatVC: ChatServiceDelegate {
    func reloadMessages() {
        self.showProgressBar()
    }
    // Scroll to bottom of table view for messages
    func receivedNewMessage() {
        let msg = self.chatManager.messages.map { (message) -> ChatType in
            switch message.messageType {
            case .text:
                if message.author == self.identity {
                    return .outText(message: message.body ?? "")
                }
                return .inText(message: message.body ?? "")
            case .media:
                if message.author == self.identity {
                    return .outImage(message: message)
                }
                return .inImage(message: message)
            @unknown default:
                return .outText(message: "")
            }
        }
        self.content = msg
        self.tableView.reloadData()
        tableView.scroll(to: .bottom, animated: true)
    }
}
