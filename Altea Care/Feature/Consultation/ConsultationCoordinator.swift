//
//  ConsultationCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class ConsultationCoordinator: BaseCoordinator, ConsultationCoordinatorOutput {
    
    var onEndConsultation: (() -> Void)?
    var onCancelConsultation: (() -> Void)?
    var onGoDashboard: (() -> Void)?
    var onGoConsultation: (() -> Void)?
    var onCloseConsultation: (() -> Void)?
    var onDetailConsultation: (() -> Void)?
    
    private let router: Router
    private let factory: ConsultationFactory
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: ConsultationFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(consultation with: ConsultationModeEntry) {
        switch with {
        case .initialScreening(let id, let orderCode, let callMA):
            self.showInitialScreening(isRoot: true, appointmentId: id, orderCode: orderCode, callMA: callMA)
        case .listConsultation(let index):
            self.showListConsultation(index: index)
        case .cancelledBooking(let id):
            self.showConsultationExpired(isRoot: true, id:"\(id)")
        case .detailConsultation(let id, let status):
            self.showDetailConsultation(isRoot: false, id: "\(id)", status: status, removeModule: true)
        case .reconsultation(let id, let orderCode, let callMA):
            self.showReconsultation(appointmentId: id, orderCode: orderCode, callMA: callMA)
        case .cancelledList:
            self.showListConsultation(index: 2)
        case .doneList:
            self.showListConsultation(index: 1)
        }
    }
    
    private func showInitialScreening(isRoot: Bool ,appointmentId: Int, orderCode: String?, callMA: Bool) {
        let view = factory.makeInitialScreening()
        view.appointmentId = appointmentId
        view.orderCode = orderCode
        view.callMA = callMA
        view.onInitialSucceed = { [weak self] (endTime) in
            guard let self = self else { return }
            if callMA{
                self.showReviewScreening(appointmentId: "\(appointmentId)", endTime: endTime)
            } else {
                self.showConsultationReviewScreen(appointmentId: "\(appointmentId)", endTime: endTime)
            }
            //            if isRoot {
            //                self.showReviewScreening(appointmentId: "\(appointmentId)", endTime: endTime)
            //            } else {
            //                self.router.dismissModule(animated: true) {
            //                    self.showConsultationReviewScreen(appointmentId: "\(appointmentId)", endTime: endTime)
            //                }
            //            }
        }
        view.onClosed = { [weak self] in
            guard let self = self else { return }
            self.onCancelConsultation?()
        }
        view.onCancel = { [weak self] (reason) in
            guard let self = self else { return }
            self.showRequestCancel(appointmentId: appointmentId, reason: reason)
        }
        
        if isRoot {
            router.setRootModule(view, hideBar: true, animation: .bottomUp)
        } else {
            router.present(view, animated: true, mode: .fullScreen, isWrapNavigation: true)
        }
    }
    
    private func showReviewScreening(appointmentId: String, endTime: String) {
        let view = factory.makeReviewScreening()
        view.appointmentId = appointmentId
        view.endTime = endTime
        view.onReviewed = { [weak self] (id) in
            guard let self = self else { return }
            self.runPaymentFlow(id: id)
        }
        view.onCanceled = { [weak self] in
            guard let self = self else { return }
            self.onCancelConsultation?()
        }
        view.onClosed = { [weak self] in
            guard let self = self else { return }
            self.onEndConsultation?()
        }
        router.setRootModule(view, hideBar: false, animation: .bottomUp)
    }
    
    private func showConsultationReviewScreen(appointmentId: String, endTime: String) {
        let view = factory.makeConsultationReview()
        view.appointmentId = appointmentId
        view.endTime = endTime
        view.onCheckMedicalResume = { [weak self] in
            guard let self = self else { return }
            self.onDetailConsultation?()
        }
        router.setRootModule(view, hideBar: true, animation: .bottomUp)
    }
    
    private func showListConsultation(index: Int? = nil) {
        let view = factory.makeListConsultation()
        view.goToIndex = index
        view.ongoingView.onConsultationTapped = { [weak self] (model) in
            guard let self = self else { return }
            self.showDetailConsultation(isRoot: false, id: model.id, status: model.status)
        }
        
        view.historyView.onConsultationTapped = { [weak self] (model) in
            guard let self = self else { return }
            self.showDetailConsultation(isRoot: false, id: model.id, status: model.status)
        }
        
        view.cancelView.onConsultationTapped = { [weak self] (model) in
            guard let self = self else { return }
            self.showConsultationExpired(isRoot: false, id: model.id)
        }
        
        view.ongoingView.onConsultationCallingTapped = { [weak self] (appointmentId, orderCode, isMA) in
            guard let self = self else { return }
            self.runConsultationFlow(id: appointmentId, orderCode: orderCode, callMA: isMA)
        }
        
        view.ongoingView.onPaymentTapped = { [weak self] (paymentUrl, appointmentId) in
            guard let self = self else { return }
            self.showWebView(paymentUrl: paymentUrl, appointmentId: appointmentId)
        }
        
        view.ongoingView.onPaymentMethod = { [weak self] (id) in
            guard let self = self else { return }
            self.runPaymentFlow(id: id)
        }
        
        view.ongoingView.onOutsideOperatingHour = {  [weak self] setting in
            self?.showOutsideOperatingHour(setting: setting){
                
            }
        }
        router.setRootModule(view)
    }
    
    private func showDetailConsultation(isRoot: Bool, id: String, status: ConsultationStatus, index: Int? = nil, removeModule: Bool = false) {
        let view = factory.makeDetailConsultaion()
        if (status == .processingResume) {
            view.goToIndex = 1
        } else {
            view.goToIndex = index
        }
        view.isRoot = isRoot
        view.patientView.id = id
        view.patientView.status = status
        view.resumeView.id = id
        view.documentView.id = id
        view.receiptView.id = id
        
        view.patientView.onConsultation = { [weak self] (id, isFromListDoctor) in
            guard let self = self else { return }
            self.runCreateBooking(id: id, isFromListDoctor: isFromListDoctor)
            //            self.showInitialScreening(isRoot: false, appointmentId: id, callMA: false)
        }
        
        view.patientView.onConsultationCallingTapped = { [weak self] (appointmentId, orderCode) in
            guard let self = self else { return }
            self.runConsultationFlow(id: appointmentId, orderCode: orderCode, callMA: false)
        }
        
        view.patientView.onCountdownShow = {  [weak self] schedule in
            self?.showCountDownView(schedule: schedule)
        }
        
        view.goDashboard = { [weak self] in
            guard let self = self else { return }
            self.onGoDashboard?()
        }
        
        view.onBackTapped = { [weak self] in
            guard let self = self else { return }
            switch removeModule {
            case true:
                self.router.dismissModule(animated: true) {
                    self.onEndConsultation?()
                    self.removeDependency(self)
                }
            case false:
                self.router.popModule(animated: true)
            }
        }
        
        if isRoot == true{
            view.isRoot = true
            router.setRootModule(view, hideBar: false, animation: .bottomUp)
            
        }else{
            view.isRoot = false
            router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
        }
    }
    
    private func showConsultationExpired(isRoot: Bool, id: String) {
        let view = factory.makeConsultationExpired()
        view.idAppointment = Int(id) ?? 0
        
        view.onClosed = { [weak self] in
            guard let self = self else { return }
            self.onGoDashboard?()
        }
        
        if isRoot{
            view.isRoot = true
            router.setRootModule(view, hideBar: false, animation: .bottomUp)
        }else{
            view.isRoot = false
            router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
        }
    }
    
    private func runPaymentFlow(id: String) {
        var (coordinator, module) = coordinatorFactory.makePaymentCoordinator()
        coordinator.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.onEndConsultation?()
                self.removeDependency(coordinator)
            }
        }
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.dismissModule(animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.onGoDashboard?()
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "goToDashboard"), object: nil)
                        self.removeDependency(coordinator)
                    }
                }
            }
        }
        coordinator.onPaymentCanceled = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.onEndConsultation?()
                self.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        router.present(module)
        coordinator.start(payment: .basic(id: id))
    }
    
    private func runConsultationFlow(id: Int, orderCode: String?, callMA: Bool) {
        var (coordinator, module) = coordinatorFactory.makeConsultationCoordinator()
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.onGoDashboard?()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onEndBooking"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        coordinator.onCancelConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onCancelConsultation"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        coordinator.onCloseConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        coordinator.onDetailConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.showDetailConsultation(isRoot: false, id: "\(id)", status: .done, index: 1)
                self.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        router.present(module)
        if callMA {
            coordinator.start(consultation: .reconsultation(id, orderCode, callMA))
        } else {
            coordinator.start(consultation: .initialScreening(id, orderCode, callMA))
        }
    }
    
    private func runCreateBooking(id: String, isFromListDoctor: Bool) {
        var (coordinator, module) = coordinatorFactory.makeBookingCoordinator()
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                //                    self.onEndBooking?()
                self.removeDependency(coordinator)
            }
        }
        //            coordinator.onCancelConsultation = { [weak self] in
        //                guard let self = self else { return }
        //                self.router.dismissModule(animated: true) {
        //                    self.removeDependency(coordinator)
        //                }
        //            }
        
        coordinator.gotoMyConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: false) {
                self.router.popToRootModule(animated: false)
                self.showListConsultation()
                self.removeDependency(coordinator)
            }
        }
        addDependency(coordinator)
        router.present(module)
        //        router.push(module)
        
        coordinator.start(booking: .detailDoctor(id, isFromListDoctor))
    }
    
    private func showWebView(paymentUrl : String, appointmentId : Int){
        let view = factory.makeWebViewPayment()
        view.paymentUrl = paymentUrl
        view.appointmentId = appointmentId
        view.checkStatusPaymentTappedPayed = { [weak self] (appointmentId) in
            guard let self = self else { return }
            self.showReview(appintmentId: appointmentId)
        }
        view.onBackTapped = { [weak self]  in
            guard let self = self else { return }
            self.showConfirmationView()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    private func showReview(appintmentId : Int) {
        let view = factory.makePaymentReview()
        view.appointmentId = appintmentId
        view.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.onEndConsultation?()
        }
        view.goDashboard = { [weak self] in
            guard let self = self else { return }
            self.onGoDashboard?()
        }
        router.push(view, animated: true, hideBar: false, hideBottomBar: true, completion: nil)
    }
    
    private func showConfirmationView() {
        let view = factory.makeCloseConfirmationView()
        view.onApproveTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.onGoDashboard?()
            }
        }
        router.pushPanModal(view)
    }
    
    private func showOutsideOperatingHour(setting: SettingModel, gotoMyConsultation: @escaping ()->Void){
        let view = factory.makeOutsideOperatingHourView(setting: setting)
        view.onOkPressed = {
            self.router.dismissPanModal()
        }
        router.pushPanModal(view)
    }
    
    private func showReconsultation(appointmentId: Int, orderCode: String?, callMA: Bool) {
        let view = factory.makeReconsultationView()
        view.onReconsultationTapped = { [weak self] in
            guard let self = self else { return }
            self.showInitialScreening(isRoot: true, appointmentId: appointmentId, orderCode: orderCode, callMA: callMA)
        }
        view.onCancel = { [weak self] (reason) in
            guard let self = self else { return }
            self.showRequestCancel(appointmentId: appointmentId, reason: reason)
        }
        view.onClose = { [weak self] in
            guard let self = self else { return }
            self.onCloseConsultation?()
        }
        router.setRootModule(view, hideBar: true, animation: .bottomUp)
    }
    
    private func showCountDownView(schedule: Schedule) {
        let view = factory.makeCountDownView()
        view.schedule = schedule
        router.pushPanModal(view)
    }
    
    private func showRequestCancel(appointmentId: Int, reason: String) {
        let view = factory.makeRequetCancelView()
        view.appointmentId = appointmentId
        view.reason = reason
        view.onCheckConsultation = { [weak self] (isSuccess) in
            guard let self = self else { return }
            if isSuccess {
                self.onCancelConsultation?()
            } else {
                self.onEndConsultation?()
            }
        }
        router.setRootModule(view, hideBar: true, animation: .bottomUp)
    }
}
