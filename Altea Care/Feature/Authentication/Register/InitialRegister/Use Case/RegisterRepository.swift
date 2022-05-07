//
//  RegisterRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation
import RxSwift

protocol RegisterRepository {
    
    func requestGetCountry() -> Single<CountryModel?>
}
