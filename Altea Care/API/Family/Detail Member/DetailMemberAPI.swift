//
//  DetailMemberAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailMemberAPI: ClientAPI {
    func request(body: DetailMemberBody) -> Single<DetailMemberResponse>
}
