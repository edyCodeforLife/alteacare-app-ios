//
//  DataBannerAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/07/21.
//

import Foundation
import RxSwift

protocol DataBannerAPI: ClientAPI {
    func requestBanner(category: BannerCategory) -> Single<DataBannerResponse>
}
