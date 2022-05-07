//
//  ScreeningReviewAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol ScreeningReviewAPI: ClientAPI {
    func request(id: String) -> Single<ScreeningReviewResponse>
}
