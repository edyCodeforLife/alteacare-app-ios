//
//  ChatHistoryView.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol ChatHistoryView: BaseView {
    var viewModel: ChatHistoryVM! { get set }
    var onChatTapped: (() -> Void)? { get set }
}
