//
//  UIButton+Extension.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import UIKit
import RxSwift

let disposeBag = DisposeBag()

extension UIButton {
    
    func setupButton(button : UIButton){
        button.backgroundColor = UIColor.primary
    }
    
    //MARK: - STATE ENABLED/DISABLED BUTTON
    func disableButton() {
        self.backgroundColor = UIColor.alteaDark3
        self.isEnabled = false
    }
    
    func enabledButton(color: UIColor) {
        self.backgroundColor = color
        self.isEnabled = true
    }
    
    func setupPrimaryButton(title: String, onTap: (()->Void)?){
        self.backgroundColor = .alteaMainColor
        self.layer.cornerRadius = 4
        self.setTitleColor(.white, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font =  .systemFont(ofSize: 16)
        self.rx.tap.bind{
            onTap?()
        }.disposed(by: disposeBag)
    }
    
    func setupSecondaryButton(title: String, onTap: (()->Void)?){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.setTitleColor(.alteaMainColor, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font =  .systemFont(ofSize: 14)
        self.layer.borderColor = UIColor.alteaMainColor.cgColor
        self.rx.tap.bind{
            onTap?()
        }.disposed(by: disposeBag)
    }
}
