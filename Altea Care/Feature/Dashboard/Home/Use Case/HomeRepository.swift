//
//  HomeRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func requestSpecialistPopular() -> Single<[ListSpecialistModel]>
    func requestGetUserData() -> Single<UserHomeData>
    func requestList(body: ListConsultationBody) -> Single<OngoingConsultation>
    func requestBanner(category: BannerCategory) -> Single<[BannerModel]>
    func requestList() -> Single<ListMemberModel>
    func requestForceUpdate() -> Single<ForceUpdateModel>
    func requestWidgets() -> Single<[WidgetModel]>
}
