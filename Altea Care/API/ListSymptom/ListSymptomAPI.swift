//
//  SymptomAPI.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import RxSwift

protocol ListSymptomAPI : ClientAPI {
    func requestSymptomListSearch(body: ListSymptomBody) -> Single<ListSymptomResponse>
}
