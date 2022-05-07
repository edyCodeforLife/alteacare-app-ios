//
//  BaseView.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol BaseView: NSObjectProtocol, Presentable, Bindable { }
protocol Bindable {
    func bindViewModel()
}
