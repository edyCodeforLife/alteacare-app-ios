//
//  OngoingConsultationRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

class OngoingConsultationRepositoryImpl: OngoingConsultationRepository {
    private let disposeBag = DisposeBag()
    private let listConsultationAPI: ListConsultationAPI
    private let detailConsultationAPI: DetailConsultationAPI
    private let listMemberAPI: ListMemberAPI
    
    init(listMemberAPI: ListMemberAPI, listConsultationAPI: ListConsultationAPI, detailConsultationAPI: DetailConsultationAPI) {
        self.listConsultationAPI = listConsultationAPI
        self.detailConsultationAPI = detailConsultationAPI
        self.listMemberAPI = listMemberAPI
    }
    
    func requestList(body: ListConsultationBody) -> Single<OngoingConsultation> {
        return Single.create { (observer) in
            self.listConsultationAPI
                .request(parameters: body.dictionary ?? [String: Any](), type: .ongoing)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listConsultationAPI
                            .httpClient
                            .verify()
                            .andThen(self.listConsultationAPI
                                        .request(parameters: body.dictionary ?? [String: Any](), type: .ongoing))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: ListConsultationResponse) -> Result<OngoingConsultation, HTTPError> {
        if let data = response.data, response.status {
            let model = data.map { (res) -> OngoingConsultationModel in
                var transaction: ConsultationTransactionModel? = nil
                
                if let trx = res.transaction {
                    transaction = ConsultationTransactionModel(bank: trx.bank ?? "", redirectionType: TransactionRedirectionType(rawValue: trx.type ?? "") ?? .unkown, vaNumber: trx.vaNumber, refId: trx.refId, total: trx.total, expiredAt: trx.expiredAt, paymentUrl: trx.paymentUrl)
                }
                
                return OngoingConsultationModel(id: "\(res.id ?? 0)",
                                                orderCode: res.orderCode ?? "",
                                                status: ConsultationStatus(rawValue: res.status ?? "") ?? .unknown,
                                                statusDetail: res.statusDetail?.label ?? "",
                                                statusBgColor: UIColor(hexString: res.statusDetail?.bgColor ?? ""),
                                                statusTextColor: UIColor(hexString: res.statusDetail?.textColor ?? ""),
                                                hospitalName: res.doctor?.hospital.name ?? "",
                                                doctorName: res.doctor?.name ?? "",
                                                specialty: "\(res.doctor?.specialist.name ?? "")",
                                                date: res.schedule?.date.dateFormattedUS(),
                                                time: "\(res.schedule?.timeStart ?? "") - \(res.schedule?.timeEnd ?? "")",
                                                startTime: res.schedule?.timeStart ?? "",
                                                hospitalIcon: res.doctor?.hospital.logo ?? "",
                                                doctorImage: res.doctor?.photo?.url ?? "",
                                                transaction: transaction,
                                                dateSchedule: res.schedule?.date ?? "",
                                                patientFamilyMember: res.patient ?? res.parentUser)
            }
            let result = OngoingConsultation(isFullyLoaded: response.meta.page == response.meta.totalPage || model.isEmpty, model: model)
            return .success(result)
        } else if !response.status && ((response.data?.isEmpty) != nil) {
            let result = OngoingConsultation(isFullyLoaded: true, model: [])
            return .success(result)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestListPatient() -> Single<ListMemberModel> {
        return Single.create { (observer) in
            self.listMemberAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.listMemberAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: ListMemberResponse) -> Result<ListMemberModel, HTTPError> {
        //MARK: - FIXME
        if let status = response.status{
            if status {
                let modelMember = response.data?.patient.map { (res) in
                    return MemberModel(idMember: res.id ?? "",
                                       name: "\(res.firstName ?? "") \(res.lastName ?? "")",
                                       role: res.familyRelationType?.name ?? "",
                                       imageUser: res.cardPhoto?.formats?.medium ?? "",
                                       age: "\(res.age?.year ?? 0) \(res.age?.month ?? 0)" ,
                                       gender: res.gender ?? "",
                                       birthDate: res.birthDate ?? "",
                                       isMainProfile: res.isDefault ?? false,
                                       email : res.email,
                                       phone : res.phone
                    )
                    
                }
                let model = ListMemberModel(isFullyLoaded: false, model: modelMember)
                
                return .success(model)
            }
            return .failure(HTTPError.custom(response.message ?? ""))
        }
        return .failure(HTTPError.custom(""))
    }
    
}
