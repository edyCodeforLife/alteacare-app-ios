//
//  SettingRepository.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation
import RxSwift

protocol SettingRepository {
    func getSettingModel() -> Single<SettingModel>
}
