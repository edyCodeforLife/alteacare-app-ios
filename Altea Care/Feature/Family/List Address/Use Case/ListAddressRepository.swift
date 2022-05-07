//
//  ListAddressRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol ListAddressRepository {
    func requestList() -> Single<ListAddressModel>
    func requestDelete(body: DeleteAddressBody) -> Single<Bool>
    func requestPrimary(body: PrimaryAddressBody) -> Single<String>
}
