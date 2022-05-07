//
//  ACLabel.swift
//  Altea Care
//
//  Created by Hedy on 09/03/21.
//

import Foundation
import UIKit

class ACLabel: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupDefaultFont()
    }
    
    private func setupDefaultFont() {
        self.font = UIFont.font()
    }
    
    func setupCustomFont(size: CGFloat, fontType: FontStyle) {
        switch fontType {
        case .weight700:
            self.font = UIFont.font(size: size, fontType: .bold)
        case .weight600:
            self.font = UIFont.font(size: size, fontType: .medium)
        case .weight500:
            self.font = UIFont.font(size: size, fontType: .normal)
        case .weight400:
            self.font = UIFont.font(size: size, fontType: .thin)
        }
    }

}
