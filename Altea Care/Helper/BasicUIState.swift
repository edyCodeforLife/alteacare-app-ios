//
//  BasicUIState.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

enum BasicUIState {
    case close
    case loading
    case success(String)
    case failure(String)
    case warning(String)
}
