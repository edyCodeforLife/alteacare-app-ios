//
//  HomeWidgetApi.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 29/12/21.
//

import RxSwift

protocol WidgetAPI : ClientAPI {
    func getWidgets() -> Single<WidgetResponse>
}
