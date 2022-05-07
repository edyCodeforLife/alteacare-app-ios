//
//  SearchAutocompleteRepository.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation
import RxSwift

protocol SearchAutocompleteRepository {
    func requestEverything(q: String) -> Single<([SearchEverythingsModel], MetaSearchModel)>
}
