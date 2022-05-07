//
//  InitialScreeningRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol InitialScreeningRepository {
    func requestPatientData(body: PatientDataBody) -> Single<PatientDataModel>
    func requestToken(body: VideoTokenBody) -> Single<ScreeningModel>
    func requestSetting() -> Single<SettingData>
}
