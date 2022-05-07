//
//  ChatHistoryRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

class ChatHistoryRepositoryImpl: ChatHistoryRepository {
    
    private let disposeBag = DisposeBag()
    private let chatHistoryAPI: ChatHistoryAPI
    
    init(chatHistoryAPI: ChatHistoryAPI) {
        self.chatHistoryAPI = chatHistoryAPI
    }
    
}
