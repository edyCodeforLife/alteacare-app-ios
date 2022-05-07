//
//  DetailMemberRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol DetailMemberRepository {
    func requestDelete(body: DeleteMemberBody) -> Single<Bool>
    func requestDetail(body: DetailMemberBody) -> Single<DetailMemberModel>
}
