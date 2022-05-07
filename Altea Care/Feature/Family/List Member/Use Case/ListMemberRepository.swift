//
//  ListMemberRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol ListMemberRepository {
    func requestList() -> Single<ListMemberModel>
//    func requestDelete(body: DeleteMemberBody) -> Single<Bool>
    func requestDefaultMember(body: SetDefaultMemberBody) -> Single<Bool>
}
