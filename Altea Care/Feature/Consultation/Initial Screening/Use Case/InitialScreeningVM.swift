//
//  InitialScreeningVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class InitialScreeningVM: BaseViewModel {
    
    private let repository: InitialScreeningRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let tokenRelay = BehaviorRelay<ScreeningModel?>(value: nil)
    private let doctorRelay = BehaviorRelay<DoctorCardModel?>(value: nil)
    private let statusCallRelay = BehaviorRelay<CallStatus>(value: .onWaiting)
    private let settingRelay = BehaviorRelay<SettingData?>(value: nil)
    private var appointmendId: Int?
    private var isCallMA: Bool?
    
    private var callService: AlteaCallServiceImpl?
    private var chatService: ChatService!
    
    struct Input {
        let fetch: Observable<Int?>
        let isCallMA: Observable<Bool?>
        let requestCall: Observable<Void>
        let requestDisconnect: Observable<Void>
        let requestDestroy: Observable<Void>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let model: Driver<DoctorCardModel?>
        let token: Driver<ScreeningModel?>
        let status: Driver<CallStatus>
        let setting: Driver<SettingData?>
    }
    
    init(repository: InitialScreeningRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        self.makeRequestCall(input)
        self.makeRequestDisconnect(input)
        self.makeRequestDestroy(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      model: self.doctorRelay.asDriver().skip(1),
                      token: self.tokenRelay.asDriver().skip(1),
                      status: self.statusCallRelay.asDriver(),
                      setting: self.settingRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        let combine = Observable.combineLatest(input.fetch, input.isCallMA)
        
        combine
            .subscribe(onNext: { (id, isCallMA) in
                guard let id = id else { return }
                self.appointmendId = id
                self.isCallMA = isCallMA
                self.stateRelay.accept(.loading)
                self.requestPatientData(input, id: id)
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestCall(_ input: Input) {
        input
            .requestCall
            .subscribe(onNext: { _ in
                guard let isCallMA = self.isCallMA, let id = self.appointmendId else {
                    return
                }
                self.setupCallService(isCallMA: isCallMA, appointmentId: id)
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestDisconnect(_ input: Input) {
        input
            .requestDisconnect
            .subscribe(onNext: { _ in
                self.callService?.disconnect()
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestDestroy(_ input: Input) {
        input
            .requestDestroy
            .subscribe(onNext: { _ in
                self.callService = nil
            }).disposed(by: self.disposeBag)
    }
    
    private func requestPatientData(_ input: Input, id: Int) {
        self.repository
            .requestPatientData(body: PatientDataBody(id: "\(id)"))
            .subscribe { (result) in
                self.doctorRelay.accept(result.doctor)
                self.requestToken(input, id: id)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestToken(_ input: Input,id: Int) {
        let body = VideoTokenBody(appointmentId: "\(id)")
        self.repository
            .requestToken(body: body)
            .subscribe { (result) in
                self.tokenRelay.accept(result)
                if let isCallMA = self.isCallMA {
                    if isCallMA {
                        self.requestSetting()
                    } else {
                        self.stateRelay.accept(.close)
                        self.setupCallService(isCallMA: isCallMA, appointmentId: id)
                    }
                }
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestSetting() {
        self.repository
            .requestSetting()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.settingRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func setupCallService(isCallMA: Bool, appointmentId: Int) {
        if isCallMA {
            //Constructor
            let param: [String: Any] = ["method": "CALL_MA", "appointmentId": appointmentId]
            self.callService = AlteaCallServiceImpl(url: SocketIdentifier().baseUrl, param: param)

            //Configure Callback/Listener
            self.callService?.callback = self
            self.callService?.setListener(events: ["ME", "CALL_MA_ANSWERED", "connect_error", "socket_error"])
        } else {
            //Constructor
            let param: [String: Any] = ["method": "CONSULTATION_CALL", "appointmentId": appointmentId]
            self.callService = AlteaCallServiceImpl(url: SocketIdentifier().baseUrl, param: param)

            //Configure Callback/Listener
            self.callService?.callback = self
            self.callService?.setListener(events: ["ME", "CONSULTATION_STARTED", "connect_error", "socket_error"])
        }
        
        //Connect
        self.callService?.connect()
    }
    
}

extension InitialScreeningVM: AlteaCallService {
    
    func onConnected() {
        self.statusCallRelay.accept(.onWaiting)
    }
    
    func onDisconneted() {
        self.statusCallRelay.accept(.onError("Error! - onDisconneted"))
        self.callService?.disconnect()
    }
    
    func didReceive(eventName: String, data: [Any]) {
        switch eventName {
        case "connect_error", "socket_error", "error":
            if let error = data.first as? NSMutableDictionary {
                let message = error["message"] as? String
                self.statusCallRelay.accept(.onError(message ?? "Error!"))
            } else {
                self.statusCallRelay.accept(.onError("Error!"))
            }
            self.callService?.disconnect()
        case "ME":
            self.statusCallRelay.accept(.onWaiting)
        case "CALL_MA_ANSWERED":
            self.statusCallRelay.accept(.onCalled)
            self.callService?.disconnect()
//            self.chatService.chatClient(<#T##client: TwilioChatClient##TwilioChatClient#>, channel: <#T##TCHChannel#>, messageAdded: <#T##TCHMessage#>)
        case "CONSULTATION_STARTED":
            self.statusCallRelay.accept(.onCalled)
            self.callService?.disconnect()
        default:
            print("didReceiveEventName: \(eventName) - \(data)")
            self.callService?.disconnect()
        }
    }
    
}
