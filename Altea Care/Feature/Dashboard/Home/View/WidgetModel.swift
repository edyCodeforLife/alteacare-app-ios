//
//  MenuModel.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/12/21.
//

import Foundation

struct WidgetModel {
    let title: String
    let imageUrl: String
    let deeplinkType: LinkType
    let deeplinkUrl: String
    let needLogin: Bool
}

enum LinkType {
    case web
    case deepLink
}
