//
//  DetailAddressAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailAddressAPI: ClientAPI {
    func request(body: DetailAddressBody) -> Single<DetailAddressResponse>
}
