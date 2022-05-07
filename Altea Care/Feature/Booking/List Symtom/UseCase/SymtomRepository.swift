//
//  ReachResultRepository.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import RxSwift

protocol SymtomRepository {
    func searchSymtoms(query: String) -> Single<[SymtomResultModel]>
}
