//
//  ConsultationFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: ConsultationFactory {
    
    func makeInitialScreening() -> InitialScreeningView {
        let vc = InitialScreeningVC()
        vc.viewModel = makeInitialScreeningVM()
        return vc
    }
    
    func makeReviewScreening() -> ReviewScreeningView {
        let vc = ReviewScreeningVC()
        vc.viewModel = makeReviewScreeningVM()
        return vc
    }
    
    func makeConsultationReview() -> ReviewScreeningSpecialistView {
        let vc = ReviewScreeningSpecialist()
        vc.viewModel = makeReviewScreeningVM()
        return vc
    }
    
    func makeListConsultation() -> ListConsultationView {
        let vc = ListConsultationVC()
        vc.ongoingView = makeOngoingConsultation()
        vc.historyView = makeHistoryConsultation()
        vc.cancelView = makeCancelConsultation()
        vc.chatHistoryView = makeChatHistory()
        return vc
    }
    
    func makeOngoingConsultation() -> OngoingConsultationView {
        let vc = OngoingConsultationVC()
        vc.viewModel = makeOngogingConsultationVM()
        return vc
    }
    
    func makeHistoryConsultation() -> HistoryConsultationView {
        let vc = HistoryConsultationVC()
        vc.viewModel = makeHistoryConsultationVM()
        return vc
    }
    
    func makeCancelConsultation() -> CancelConsultationView {
        let vc = CancelConsultationVC()
        vc.viewModel = makeCancelConsultationVM()
        return vc
    }
    
    func makeChatHistory() -> ChatHistoryView {
        let vc = ChatHistoryVC()
        vc.viewModel = makeChatHistoryVM()
        return vc
    }
    
    func makeDetailConsultaion() -> DetailConsultationView {
        let vc = DetailConsultationVC()
        vc.patientView = makePatientData()
        vc.resumeView = makeMedicalResume()
        vc.documentView = makeMedicalDocument()
        vc.receiptView = makeReceipt()
        return vc
    }
    
    func makePatientData() -> PatientDataView {
        let vc = PatientDataVC()
        vc.viewModel = makePatientDataVM()
        return vc
    }
    
    func makeMedicalResume() -> MedicalResumeView {
        let vc = MedicalResumeVC()
        vc.viewModel = makeMedicalResumeVM()
        return vc
    }
    
    func makeMedicalDocument() -> MedicalDocumentView {
        let vc = MedicalDocumentVC()
        vc.viewModel = makeMedicalDocumentVM()
        return vc
    }
    
    func makeReceipt() -> ReceiptView {
        let vc = ReceiptVC()
        vc.viewModel = makeReceiptVM()
        return vc
    }
    
    func makeConsultationExpired() -> ConsulationExpiredView {
        let vc = ConsulationExpiredVC()
        vc.viewModel = makeConsulationExpiredVM()
        return vc
    }
    
    func makeWebViewPayment() -> AlteaPaymentVAView {
        let vc = AlteaPaymentWebviewVC()
        vc.viewModel = makeWebViewAlteaVM()
        return vc
    }
    
    func makePaymentReview() -> ReviewPaymentView {
        let vc = ReviewPaymentVC()
        vc.viewModel = makeReviewPaymentVM()
        return vc
    }
    
    func makeOutsideOperatingHourView(setting: SettingModel) -> OutsideOperatingHourView {
        let vc = OutsideOperatingHourViewController()
        vc.setting = setting
        return vc
    }
    
    func makeReconsultationView() -> ReconsultationView {
        let vc = ReconsultationVC()
        return vc
    }
    
    func makeCountDownView() -> CountDownView {
        let vc = CountDownViewController()
        return vc
    }
    
    func makeRequetCancelView() -> RequestCancelVC {
        let vc = RequestCancelVC()
        vc.viewModel = makeRequestCancelVM()
        return vc
    }
}
