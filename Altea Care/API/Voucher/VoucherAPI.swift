//
//  VoucherAPI.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
import RxSwift

protocol VoucherAPI : ClientAPI {
    func request(body:VoucherBody) -> Single<VoucherResponse>
}
