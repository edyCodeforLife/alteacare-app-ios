//
//  MedicalResumeView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol MedicalResumeView: BaseView {
    var viewModel: MedicalResumeVM! { get set }
    var id: String! { get set }
}
