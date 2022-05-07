//
//  VideoTokenAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol VideoTokenAPI: ClientAPI {
    func request(body: VideoTokenBody) -> Single<VideoTokenResponse>
}
