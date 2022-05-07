//
//  SetDefaultMemberAPI.swift
//  Altea Care
//
//  Created by Tiara on 03/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DefaultMemberAPI: ClientAPI {
    func requestSetAsDefault(body: SetDefaultMemberBody) -> Single<SetDefaultMemberResponse>
}
