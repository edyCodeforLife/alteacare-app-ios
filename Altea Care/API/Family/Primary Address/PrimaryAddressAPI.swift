//
//  PrimaryAddressAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PrimaryAddressAPI: ClientAPI {
    func request(body: PrimaryAddressBody) -> Single<PrimaryAddressResponse>
}
