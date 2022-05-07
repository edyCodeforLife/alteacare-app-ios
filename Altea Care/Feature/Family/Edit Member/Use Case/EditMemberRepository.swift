//
//  EditMemberRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol EditMemberRepository {
    func requestDetail(body: DetailMemberBody) -> Single<EditMemberModel>
    func requestUpdate(id: String, body: UpdateMemberBody) -> Single<Bool>
    func requestGetCountry() -> Single<CountryModel?>
    func requestGetFamilyRelations() -> Single<FamilyRelationModel?>
}
