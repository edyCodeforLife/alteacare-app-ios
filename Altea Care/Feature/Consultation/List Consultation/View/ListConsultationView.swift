//
//  ListConsultationView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ListConsultationView: BaseView {
    var ongoingView: OngoingConsultationView! { get set }
    var historyView: HistoryConsultationView! { get set }
    var cancelView: CancelConsultationView! { get set }
    var chatHistoryView: ChatHistoryView! { get set }
    var goToIndex: Int? { get set }
    func showOngoingPage()
    func showHistoryPage()
    func showCanceledPage()
    func showConversationPage()
}
