//
//  ChatView.swift
//  Altea Care
//
//  Created by Hedy on 13/03/21.
//

import Foundation

protocol ChatView: BaseView {
    var onClosed: (() -> Void)? { get set }
}
