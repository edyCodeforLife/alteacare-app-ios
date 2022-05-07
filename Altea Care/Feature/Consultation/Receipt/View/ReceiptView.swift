//
//  ReceiptView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ReceiptView: BaseView {
    var viewModel: ReceiptVM! { get set }
    var id: String! { get set }
}
