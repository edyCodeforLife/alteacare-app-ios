//
//  ConsultationExpiredRepositoryImpl.swift
//  Altea Care
//
//  Created by Tiara Mahardika on 17/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class ConsultationExpiredRepositoryImpl: ConsultationExpiredRepository {
    
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailAppointmentAPI : DetailAppointmentAPI
    
    init(detailAppointmentAPI : DetailAppointmentAPI) {
        self.detailAppointmentAPI = detailAppointmentAPI
    }
    
    func requestAppointmentDetail(body: DetailAppointmentBody) -> Single<CancelConsultationModel> {
        return Single.create { (observer) in
            self.detailAppointmentAPI
                .requestDetailAppointment(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailAppointmentResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .detailAppointmentAPI
                            .httpClient
                            .verify()
                            .andThen(self.detailAppointmentAPI.requestDetailAppointment(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformDetailModel ($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model): observer(.success(model))
                    case .failure(let error): observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformDetailModel(_ response : DetailAppointmentResponse) -> Result<CancelConsultationModel, HTTPError> {
        var transaction: ConsultationTransactionModel? = nil
        if response.status {
            if let res = response.data {
                if let trx = res.transaction {
                    transaction = ConsultationTransactionModel(bank: trx.bank ?? "", redirectionType: TransactionRedirectionType(rawValue: trx.type ?? "") ?? .unkown, vaNumber: trx.vaNumber, refId: trx.refId, total: trx.total, expiredAt: trx.expiredAt, paymentUrl: trx.paymentUrl)
                }
                
                let model =  CancelConsultationModel(id: "\(res.id)",
                                                     orderCode: res.orderCode,
                                                     status: ConsultationStatus(rawValue: res.status) ?? .unknown,
                                                     statusDetail: res.statusDetail?.label ?? "",
                                                     statusBgColor: UIColor(hexString: res.statusDetail?.bgColor ?? ""),
                                                     statusTextColor: UIColor(hexString: res.statusDetail?.textColor ?? ""),
                                                     hospitalName: res.doctor.hospital.name,
                                                     doctorName: res.doctor.name,
                                                     specialty: "\(res.doctor.specialist.name)",
                                                     date: res.schedule.date.dateFormattedUS(),
                                                     time: "\(res.schedule.timeStart ?? "") - \(res.schedule.timeEnd ?? "")",
                                                     hospitalIcon: res.doctor.hospital.logo,
                                                     doctorImage: res.doctor.photo?.url ?? "",
                                                     reason: InfoCase(rawValue: res.status) ?? .unknown,
                                                     transaction: transaction,
                                                     patientFamilyMember: res.patient ?? res.parentUser,
                                                     dateSchedule: res.schedule.date)
                return .success(model)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
}
