//
//  ListAddressAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListAddressAPI: ClientAPI {
    func request() -> Single<ListAddressResponse>
}
