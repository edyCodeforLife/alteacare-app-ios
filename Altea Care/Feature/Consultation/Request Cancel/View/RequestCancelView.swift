//
//  RequestCancelView.swift
//  Altea Care
//
//  Created by Hedy on 28/12/21.
//

import Foundation

protocol RequestCancelView: BaseView {
    var viewModel: RequestCancelVM! { get set }
    var appointmentId: Int! { get set }
    var reason: String! { get set }
    var onCheckConsultation: ((Bool) -> Void)? { get set }
}
