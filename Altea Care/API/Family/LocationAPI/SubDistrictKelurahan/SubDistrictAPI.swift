//
//  SubDistrictAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol SubDistrictAPI : ClientAPI {
    func requestSubDistrict(body : SubDistrictBody) -> Single<SubDistrictResponse>
}
