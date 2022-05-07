//
//  PatientDataVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class PatientDataVM: BaseViewModel {
    
    private let repository: PatientDataRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let patientDataRelay = BehaviorRelay<PatientDataModel?>(value: nil)
    
    struct Input {
        let fetch: Observable<String?>
//        let removeDoc : Observable<RemoveDocumentBody?>
//        let uploadDoc : Observable<Media?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let patientData : Driver<PatientDataModel?>
    }
    
    init(repository: PatientDataRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(state: self.stateRelay.asDriver().skip(1), patientData: self.patientDataRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetch
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.makeRequestFetch(id: id)
            })
            .disposed(by: self.disposeBag)
        
//        input
//            .removeDoc
//            .subscribe(onNext: { (doc) in
//                guard let doc = doc else {return}
//                self.makeRequestDeleteDoc(body: doc)
//            })
//            .disposed(by: self.disposeBag)
        
//        input
//            .uploadDoc
//            .subscribe(onNext: { (media) in
//                guard let media = media else {return}
//                self.makeRequestUploadDoc(media: media)
//            })
//            .disposed(by: self.disposeBag)

    }
    
    private func makeRequestFetch(id: String) {
        self.repository
            .requestPatientData(body: PatientDataBody(id: id))
            .subscribe { (model) in
                self.patientDataRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)

    }
    
    private func makeRequestDeleteDoc(body: RemoveDocumentBody) {
        self.repository
            .requestDeleteDocument(body: body)
            .subscribe { (model) in
                self.stateRelay.accept(.success("Berhasil Menghapus Dokumen"))
                self.makeRequestFetch(id: body.appointment_id)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestUploadDoc(media: Media) {
        let bound = "Boundary-\(NSUUID().uuidString)"
        self.repository
            .requestUploadDocument(media: media, boundary: bound)
            .subscribe { (model) in
                self.stateRelay.accept(.success("Berhasil Mengupload Dokumen"))
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
