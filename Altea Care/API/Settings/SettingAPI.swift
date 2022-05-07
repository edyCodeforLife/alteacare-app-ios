//
//  SettingAPI.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import RxSwift

protocol SettingAPI : ClientAPI {
    func getSettings() -> Single<SettingResponse>
}
