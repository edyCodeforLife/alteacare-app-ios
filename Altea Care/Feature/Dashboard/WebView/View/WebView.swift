//
//  VaccineView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/07/21.
//

import Foundation

protocol WebView : BaseView {
    var url : String! { get set }
    var goHome : (() -> Void)? { get set }
    var isNeedLogin : Bool! { get set }
}
