//
//  DetailConsultationView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol DetailConsultationView: BaseView {
    var patientView: PatientDataView! { get set }
    var resumeView: MedicalResumeView! { get set }
    var documentView: MedicalDocumentView! { get set }
    var receiptView: ReceiptView! { get set }
    var isRoot : Bool { get set }
    var goToIndex: Int? { get set }
    var goDashboard : (() -> Void)? { get set }
    var onBackTapped: (() -> Void)? {get set}
}
