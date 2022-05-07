//
//  InitialChangeProfileVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxCocoa
import RxSwift

class InitialChangeProfileVM : BaseViewModel {
    
    private let repository : InitialChangeProfileRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let profileRelay =  BehaviorRelay<ChangeProfileModel?>(value: nil)
    private let imageUploadRelay =  BehaviorRelay<UploadImageModel?>(value: nil)
    private let updateAvatarRelay = BehaviorRelay<UpdateAvatarResModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void?>
        let sendImage : Observable<Media?>
        let updateAvatarInput : Observable<UpdateAvatarBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let userData : Driver<ChangeProfileModel?>
        let sendImageOutput : Driver<UploadImageModel?>
        let updateAvatarOutput : Driver<UpdateAvatarResModel?>
    }
    
    init(repository : InitialChangeProfileRepository) {
        self.repository = repository
    }
    
    private func makeProfile(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestProfileData()
            }.disposed(by: self.disposeBag)
    }
    
    func requestProfileData(){
        self.repository
            .requestGetUserData()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.profileRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestUploadImaget(_ input: Input){
        input
            .sendImage
            .subscribe(onNext: { (media) in
                guard let media = media else { return }
                self.requestUploadImage(media: media)
            }).disposed(by: self.disposeBag)
    }
    
    private func requestUploadImage(media : Media){
        let bound = "Boundary-\(NSUUID().uuidString)"
        self.repository
            .uploadImage(media: media, boundary: bound)
            .subscribe { (model) in
                self.stateRelay.accept(.success("Berhasil Mengunggah Foto Profile"))
                self.requestUpdateAvatar(body: UpdateAvatarBody(avatar: model.id ?? ""))
            } onFailure: { (error) in
                self.stateRelay.accept(.failure("Image belum sesuai format"))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestUpdateAvatar(_ input : Input){
        input
            .updateAvatarInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestUpdateAvatar(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure("Request update avatar belum berhasil"))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestUpdateAvatar(body : UpdateAvatarBody){
        self.repository
            .requestUpdateAvatar(body: body)
            .subscribe { (result) in
                self.requestProfileData()
                self.updateAvatarRelay.accept(result)
            } onFailure: {  (error) in
                self.stateRelay.accept(.failure("Update Avatar belum berhasil"))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeProfile(input)
        self.makeRequestUploadImaget(input)
        self.makeRequestUpdateAvatar(input)
        return Output(state: self.stateRelay.asDriver().skip(1), userData: self.profileRelay.asDriver().skip(1), sendImageOutput: self.imageUploadRelay.asDriver().skip(1), updateAvatarOutput: self.updateAvatarRelay.asDriver().skip(1))
    }
}
