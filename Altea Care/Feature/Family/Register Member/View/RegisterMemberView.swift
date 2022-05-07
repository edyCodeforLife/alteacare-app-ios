//
//  RegisterMemberView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol RegisterMemberView: BaseView {
    var resgistTapped: (() -> Void)? { get set }
    var viewModel: RegisterMemberVM! { get set }
    var patientData: AddMemberBody? { get set }
    var id: String? { get set }
    var isFromDetail: Bool! { get set }
}
