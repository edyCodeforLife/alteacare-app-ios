//
//  AlteaCallService.swift
//  Altea Care
//
//  Created by Hedy on 23/05/21.
//

import Foundation
import SocketIO

protocol AlteaCallService {
    func onConnected()
    func onDisconneted()
    func didReceive(eventName: String, data: [Any])
}

class AlteaCallServiceImpl: WebsocketService {
    var callback: AlteaCallService?
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var resetAck: SocketAckEmitter?
    private var option: SocketIOClientConfiguration = []
    
    init(url: URL, param: [String: Any]?) {
        self.option = [.log(true), .compress]
        
        if let param = param {
            self.option.insert(.connectParams(param))
        }
        
        manager = SocketManager(socketURL: url, config: option)
        socket = manager.defaultSocket
        
        self.setupBasicEvent()
    }
    
    private func setupBasicEvent() {
        socket.on(clientEvent: .connect) { _, _ in
            self.callback?.onConnected()
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
            self.callback?.onDisconneted()
        }
        
        socket.on(clientEvent: .error) { data, _ in
            self.callback?.didReceive(eventName: "error", data: data)
        }
    }
    
    func setListener(events: [String]) {
        for event in events {
            socket.on(event) { data, _ in
                self.callback?.didReceive(eventName: event, data: data)
            }
        }
    }
    
    func send(event: String, value: [String : Any]) {
        socket.emit(event, value)
    }
    
    func connect() {
        socket.connect(withPayload: ["token": HTTPAuth.shared.bearerToken ?? ""])
    }
    
    func reconnect(reason: String) {
        socket.setReconnecting(reason: reason)
    }
    
    func disconnect() {
        socket.disconnect()
//        socket = nil
    }
}
