//
//  ConsultationFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol ConsultationFactory {
    func makeInitialScreening() -> InitialScreeningView
    func makeReviewScreening() -> ReviewScreeningView
    func makeConsultationReview() -> ReviewScreeningSpecialistView
    func makeListConsultation() -> ListConsultationView
    func makeOngoingConsultation() -> OngoingConsultationView
    func makeHistoryConsultation() -> HistoryConsultationView
    func makeCancelConsultation() -> CancelConsultationView
    func makeChatHistory() -> ChatHistoryView
    func makeDetailConsultaion() -> DetailConsultationView
    func makePatientData() -> PatientDataView
    func makeMedicalResume() -> MedicalResumeView
    func makeMedicalDocument() -> MedicalDocumentView
    func makeReceipt() -> ReceiptView
    func makeConsultationExpired() -> ConsulationExpiredView
    func makeWebViewPayment() -> AlteaPaymentVAView
    func makePaymentReview() -> ReviewPaymentView
    func makeOutsideOperatingHourView(setting: SettingModel) -> OutsideOperatingHourView
    func makeReconsultationView() -> ReconsultationView
    func makeCountDownView() -> CountDownView
    func makeRequetCancelView() -> RequestCancelVC
    func makeCloseConfirmationView() -> ClosePaymentConfirmationView
}
