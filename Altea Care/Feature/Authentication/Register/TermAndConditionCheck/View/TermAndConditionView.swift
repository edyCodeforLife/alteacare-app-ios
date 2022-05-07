//
//  TermAndConditionView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol TermAndConditionView : BaseView {
    var viewModel: TermAndConditionVM! { get set }
    var onTermChecklish: (() -> Void)? { get set }
    var onButtonSubmitTapped: (() -> Void)? { get set }
}
