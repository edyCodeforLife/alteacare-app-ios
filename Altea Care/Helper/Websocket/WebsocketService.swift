//
//  WebsocketService.swift
//  Altea Care
//
//  Created by Hedy on 23/05/21.
//

import Foundation

protocol WebsocketService {
    func connect()
    func reconnect(reason: String)
    func disconnect()
    func setListener(events: [String])
    func send(event: String, value: [String: Any])
}
