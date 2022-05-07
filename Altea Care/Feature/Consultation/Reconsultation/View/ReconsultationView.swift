//
//  ReconsultationView.swift
//  Altea Care
//
//  Created by Hedy on 18/12/21.
//

import Foundation

protocol ReconsultationView: BaseView {
    var onReconsultationTapped: (() -> Void)? { get set }
    var onCancel: ((String) -> Void)? { get set }
    var onClose: (() -> Void)? { get set }
}
