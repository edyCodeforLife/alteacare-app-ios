//
//  EditAddressAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol EditAddressAPI: ClientAPI {
    func request(id: String, body: EditAddressBody) -> Single<EditAddressResponse>
}
