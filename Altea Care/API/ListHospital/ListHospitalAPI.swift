//
//  ListHospitalAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListHospitalAPI : ClientAPI {
    func requestListHospital() -> Single<ListHospitalResponse>
}
