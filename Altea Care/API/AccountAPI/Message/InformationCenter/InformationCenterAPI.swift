//
//  InformationCenterAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/08/21.
//

import Foundation
import RxSwift

protocol InformationCenterAPI : ClientAPI {
    func request() -> Single<InformationCenterResponse>
}
