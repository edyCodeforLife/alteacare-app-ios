//
//  ChatService.swift
//  Altea Care
//
//  Created by Hedy on 20/03/21.
//

import Foundation
import UIKit
import TwilioChatClient
import TwilioVideo

protocol ChatServiceDelegate: AnyObject {
    func reloadMessages()
    func receivedNewMessage()
}

class ChatService: NSObject, TwilioChatClientDelegate {
    
    // the unique name of the channel you create
    var uniqueChannelName = ""
    var friendlyChannelName = ""
    
    // For the quickstart, this will be the view controller
    weak var delegate: ChatServiceDelegate?
    
    // MARK: Chat variables
    private var client: TwilioChatClient?
    private var channel: TCHChannel?
    private(set) var messages: [TCHMessage] = []
    private var identity: String?
    
    static let kMessageImageMimeType = "image/*"
    static let kMessagePdfMimeType = "application/pdf"
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        guard status == .completed else {
            return
        }
        checkChannelCreation { (_, channel) in
            if let channel = channel {
                self.joinChannel(channel)
            } else {
                self.createChannel { (success, channel) in
                    if success, let channel = channel {
                        self.joinChannel(channel)
                    }
                }
            }
        }
    }
    
    // Called whenever a channel we've joined receives a new message
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel,
                    messageAdded message: TCHMessage) {
        messages.append(message)
        
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.reloadMessages()
                if self.messages.count > 0 {
                    delegate.receivedNewMessage()
                }
            }
        }
    }
    
    func leaveChannel() {
        channel?.leave { result in
            if (result.isSuccessful()) {
                print("leave channel")
            }
        }
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        print("Chat Client Token will expire.")
        // the chat token is about to expire, so refresh it
        refreshAccessToken()
    }
    
    private func refreshAccessToken() {
        guard let identity = identity else {
            return
        }
        let urlString = "\(TOKEN_URL)?identity=\(identity)"
        
        ChatTokenUtils.retrieveToken(url: urlString) { (token, _, error) in
            guard let token = token else {
                print("Error retrieving token: \(error.debugDescription)")
                return
            }
            self.client?.updateToken(token, completion: { (result) in
                if (result.isSuccessful()) {
                    print("Access token refreshed")
                } else {
                    print("Unable to refresh access token")
                }
            })
        }
    }
    
    func sendMessage(_ messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        if let messages = self.channel?.messages {
            print("send message : \(self.channel?.friendlyName ?? ""), sid : \(self.channel?.sid ?? "")")
            let messageOptions = TCHMessageOptions().withBody(messageText)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
                if result.isSuccessful(){
                    print("sukses kirim text")
                } else {
                    print("gagal kirim text")
                }
            })
        }
    }
    
    func sendMessageFile(_ image: Data, completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        let inputStream = InputStream(data: image)
        
        if let messages = self.channel?.messages {
            let messageOptions = TCHMessageOptions().withMediaStream(inputStream, contentType: ChatService.kMessageImageMimeType, defaultFilename: "filename.jpg", onStarted: {
            print("upload started")
            }, onProgress: { (bytes) in
                print("media upload progress image: \(bytes)")
                
            }) { (mediaSid) in
                print("mediaSid :image \(mediaSid)")
            }
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
                if result.isSuccessful(){
                    print("sukses kirim iamge")
                } else {
                    print("gagal kirim image")
                }
            })
        }
    }
    
    func sendMessagePDF(_ image: Data, completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        let inputStream = InputStream(data: image)
        
        if let messages = self.channel?.messages {
            let messageOptions = TCHMessageOptions().withMediaStream(inputStream, contentType: ChatService.kMessagePdfMimeType, defaultFilename: "\(arc4random()).pdf", onStarted: {
                
            }, onProgress: { (bytes) in
                
            }) { (mediaSid) in
                
            }
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
                if result.isSuccessful() {
                    // ...
                } else {
                    // ...
                }
            })
        }
    }
    
    func login(_ identity: String, accessToken : String, uniqueRoom: String, roomName: String, completion: @escaping (Bool) -> Void) {
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are
        // calling a Twilio function, as described in the Quickstart docs
        //        let urlString = "\(TOKEN_URL)?identity=\(identity)"
        self.identity = identity
        self.uniqueChannelName = uniqueRoom
        self.friendlyChannelName = roomName
        
        TwilioChatClient.chatClient(withToken: accessToken, properties: nil,
                                    delegate: self) { (result, chatClient) in
            self.client = chatClient
            completion(result.isSuccessful())
        }
    }
    
    func shutdown() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }
    
    private func createChannel(_ completion: @escaping (Bool, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            return
        }
        // Create the channel if it hasn't been created yet
        let options: [String: Any] = [
            TCHChannelOptionUniqueName: uniqueChannelName,
            TCHChannelOptionFriendlyName: friendlyChannelName,
            TCHChannelOptionType: TCHChannelType.private.rawValue
        ]
        
        channelsList.createChannel(options: options, completion: { channelResult, channel in
            if channelResult.isSuccessful() {
                print("Channel created.")
            } else {
                print("Channel NOT created.")
            }
            completion(channelResult.isSuccessful(), channel)
        })
    }
    
    private func checkChannelCreation(_ completion: @escaping(TCHResult?, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            return
        }
        channelsList.channel(withSidOrUniqueName: uniqueChannelName, completion: { (result, channel) in
            completion(result, channel)
        })
    }
    
    private func joinChannel(_ channel: TCHChannel) {
        self.channel = channel
        if channel.status == .joined {
            print("Current user already exists in channel")
        } else {
            channel.join(completion: { result in
                /// ...
            })
        }
    }
    
    
}

struct ChatTokenUtils {
    
    static func retrieveToken(url: String, completion: @escaping (String?, String?, Error?) -> Void) {
        if let requestURL = URL(string: url) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: requestURL, completionHandler: { (data, _, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let tokenData = json as? [String: String] {
                            let token = tokenData["token"]
                            let identity = tokenData["identity"]
                            completion(token, identity, error)
                        } else {
                            completion(nil, nil, nil)
                        }
                    } catch let error as NSError {
                        completion(nil, nil, error)
                    }
                } else {
                    completion(nil, nil, error)
                }
            })
            task.resume()
        }
    }
}


let TOKEN_URL = "https://bazaar-viper-5272.twil.io/chat-token" // "https://YOUR_TWILIO_FUNCTION_DOMAIN_HERE.twil.io/chat-token"
