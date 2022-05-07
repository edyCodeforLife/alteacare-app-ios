//
//  AccountModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import UIKit

struct AccountOptionModel {
    var title : String
    var option : [ProfileOption]
}

struct ProfileOption {
    var tittle : String
    var imageOption : UIImage
    var isHiddenChevron : Bool
    
    let handler: (() -> Void)
}
