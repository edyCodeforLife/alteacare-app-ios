//
//  CountryAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 07/05/21.
//

import Foundation
import RxSwift

protocol CountryAPI : ClientAPI {
    func request() -> Single<CountryResponse>
}
