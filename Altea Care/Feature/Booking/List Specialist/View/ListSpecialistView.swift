//
//  ListSpecialistView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ListSpecialistView: BaseView {
    var viewModel: ListSpecialistVM! { get set }
    var searchQuery: String! { get set }
    var isShowBackButton: Bool! { get set }
    var onSpecialistTapped: ((String, String) -> Void)? { get set }
    var onBackButtonPressed: (()-> Void)? { get set }
}
