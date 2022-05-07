//
//  SearchAPI.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation
import RxSwift

protocol SearchAPI : ClientAPI{
    func requestEverything(q: String) -> Single<SearchResponse>
}
