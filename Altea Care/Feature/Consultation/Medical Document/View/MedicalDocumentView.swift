//
//  MedicalDocumentView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol MedicalDocumentView: BaseView {
    var viewModel: MedicalDocumentVM! { get set }
    var id: String! { get set }
}
