//
//  AddAddressAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddAddressAPI: ClientAPI {
    func request(body: AddAddressBody) -> Single<AddAddressResponse>
}
