//
//  FamilyRelationAPI.swift
//  Altea Care
//
//  Created by Tiara on 02/09/21.
//

import Foundation
import RxSwift

protocol FamilyRelationAPI : ClientAPI {
    func request() -> Single<FamilyRelationResponse>
}
