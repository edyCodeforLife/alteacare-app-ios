//
//  CitiesAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol CitiesAPI : ClientAPI {
    func requestCities(body : CitiesBody) -> Single<CitiesResponse>
}
