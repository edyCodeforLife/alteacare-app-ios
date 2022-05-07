//
//  ForceUpdateAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ForceUpdateAPI : ClientAPI {
    func requestForceUpdate() -> Single<ForceUpdateResponse>
}
