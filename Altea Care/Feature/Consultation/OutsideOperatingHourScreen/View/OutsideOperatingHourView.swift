//
//  OutsideOperatingHourView.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation


protocol OutsideOperatingHourView: BaseView {
    var onBackPressed: (()-> Void)? {set get}
    var onOkPressed: (()-> Void)? {set get}
}
