//
//  AddMemberRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol AddMemberRepository {
    func requestAdd(body: AddMemberBody) -> Single<AddMemberModel>
    func requestGetCountry() -> Single<CountryModel?>
    func requestGetFamilyRelations() -> Single<FamilyRelationModel?>
}
