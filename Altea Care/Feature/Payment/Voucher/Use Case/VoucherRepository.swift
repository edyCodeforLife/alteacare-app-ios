//
//  VoucherRepository.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
import RxSwift

protocol VoucherRepository {
    func request(body: VoucherBody) -> Single<(VoucherModel)>
}
