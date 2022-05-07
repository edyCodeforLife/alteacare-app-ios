//
//  PaymentCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class PaymentCoordinator: BaseCoordinator, PaymentCoordinatorOutput {
    
    var onPaymentVerification: (() -> Void)?
    var onPaymentReviewed: (() -> Void)?
    var onPaymentCanceled: (() -> Void)?
    var onPaymentPickPaymentMethod: (() -> Void)?
    var idAppointment: String!
    var onGoDashboard: (() -> Void)?
    private lazy var paymentInqView = factory.makeInquiryPayment()
    
    private let router: Router
    private let factory: PaymentFactory
    private let coordinatorFactory: CoordinatorFactory
    private let notifiactionCenter = NotificationCenter.default
    init(router: Router, factory: PaymentFactory,coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        
    }
    
    override func start(payment with: PaymentModeEntry) {
        switch with{
        case .paymentReview(let id):
            self.idAppointment = "\(id)"
            showReview(isRoot: true, appointmentId: id)
        case .waitingForPayment(id: let id):
            self.idAppointment = "\(id)"
            showInquiry()
        case .basic(id: let id):
            self.idAppointment = id
            showInquiry()
        }
    }
    
    private func showInquiry() {
        paymentInqView = factory.makeInquiryPayment()
        paymentInqView.consultationId = self.idAppointment
        paymentInqView.onInquiry = { [weak self] (appointmentId) in
            guard let self = self else { return }
            self.showReview(isRoot: false, appointmentId: appointmentId)
        }
        paymentInqView.onClosed = { [weak self] in
            guard let self = self else { return }
            self.onPaymentCanceled?()
        }
        paymentInqView.onMethodTapped = { [weak self] (id, voucher) in
            guard let self = self else { return }
            self.showPaymentMethod(consultationId: id,voucher: voucher)
        }
        
        paymentInqView.onApplyVoucher = { [weak self] (id) in
        guard let self = self else { return }
            self.showVoucher(id: id)
        }
        router.setRootModule(paymentInqView, hideBar: false, animation: .bottomUp)
    }
    
    private func showPaymentMethod(consultationId: Int, voucher: VoucherBody?) {
        let view = factory.makePaymentMethod()
        view.consultationId = consultationId
        view.voucherCode = voucher
        view.goToWebView = { [weak self] (PaymentUrl, consultationId) in
            guard let self = self else { return }
            self.showWebView(paymentUrl: PaymentUrl, consultationId: consultationId)
        }
        view.goToReview = { [weak self] (consultationId) in
            guard let self = self else { return }
            self.showReview(isRoot: false, appointmentId: consultationId)
        }
        router.push(view, animated: true, hideBar: false, hideBottomBar: true, completion: nil)
        
    }
    
    private func showWebView(paymentUrl : String, consultationId : Int){
        let view = factory.makeWebViewMethod()
        view.paymentUrl = paymentUrl
        view.appointmentId = consultationId
        view.checkStatusPaymentTappedPayed = { [weak self] (appointmentId) in
            guard let self = self else { return }
            self.showReview(isRoot: false, appointmentId: appointmentId)
        }
        view.onBackTapped = { [weak self]  in
            guard let self = self else { return }
            self.showConfirmationView()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    private func showReview(isRoot: Bool, appointmentId : Int) {
        let view = factory.makeReviewPayment()
        view.appointmentId = appointmentId
        view.isRoot = isRoot
        view.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.onPaymentReviewed?()
        }
        view.goDashboard = { [weak self] in
            guard let self = self else { return }
            self.onGoDashboard?()
        }
        
        router.setRootModule(view, hideBar: false, animation: .bottomUp)
    }
    
    private func showConfirmationView() {
        let view = factory.makeCloseConfirmationView()
        view.onApproveTapped = { [weak self] in
            guard let self = self else { return }
            self.onGoDashboard?()
        }
        router.pushPanModal(view)
    }

    private func runMenubarFlow(with option: DeepLinkOption? = nil,selectTab: Int) {
        var (coordinator, module) = coordinatorFactory.makeMenubarCoordinator()
        addDependency(coordinator)
        router.setRootModule(module, hideBar: true, animation: .bottomUp)
        coordinator.start(with: option, indexTab: .tabIndex(selectTab))
    }
    
    private func showVoucher(id : String) {
        let view = factory.makeVoucherView()
        view.transactionId = id
        view.voucherOnUsed = { voucher in
            self.router.dismissModule(animated: true){
                self.paymentInqView.voucherUsed = voucher
            }
        }
        router.present(view, animated: true, mode: .basic, isWrapNavigation: true)
    }
}
