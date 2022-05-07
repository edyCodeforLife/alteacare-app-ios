//
//  InitialScreeningView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol InitialScreeningView: BaseView {
    var viewModel: InitialScreeningVM! { get set }
    var onInitialSucceed: ((String) -> Void)? { get set }
    var onClosed: (() -> Void)? { get set }
    var onCancel: ((String) -> Void)? { get set }
    var appointmentId: Int! { get set }
    var orderCode: String? { get set }
    var callMA: Bool! { get set }
}
