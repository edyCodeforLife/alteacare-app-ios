//
//  ForceUpdateView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 19/09/21.
//

import Foundation


protocol ForceUpdateView : BaseView {
    var viewModel : ForceUpdateVM! { get set }
    var goToAppStore : (() -> Void)? { get set }
}
