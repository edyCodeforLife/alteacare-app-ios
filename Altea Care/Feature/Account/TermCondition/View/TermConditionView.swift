//
//  TermConditionView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol TermConditionView : BaseView {
    var viewModel : TermConditionVM! { get set }
    var onUnderstandTapped : (() -> Void)? { get set }
}
