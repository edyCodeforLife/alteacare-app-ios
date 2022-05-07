//
//  FilterButtonCollectionViewCell.swift
//  Altea Care
//
//  Created by Hedy on 8/3/21.
//

import UIKit

class FilterButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    var onTapped: (() -> Void)?
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.setupBackgroundColorSelected()
            } else {
                self.setupBackgroundColorDeselected()
            }
        }
    }
    
    func setupBackgroundColorSelected() {
        self.container.layer.borderColor = UIColor.white.cgColor
        self.buttonLabel.textColor = .white
        self.container.backgroundColor = .alteaMainColor
    }
    
    func setupBackgroundColorDeselected() {
        self.container.layer.borderColor = UIColor.alteaMainColor.cgColor
        self.buttonLabel.textColor = .alteaMainColor
        self.container.backgroundColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setTapped()
        self.setupUI()
    }
    
    private func setupUI() {
        self.container.layer.cornerRadius = self.container.layer.bounds.height / 2
        self.container.clipsToBounds = true
        self.container.layer.borderWidth = 1.5
        self.container.layer.borderColor = UIColor.alteaMainColor.cgColor
        self.buttonLabel.textColor = .alteaMainColor
        self.container.backgroundColor = .white
//        self.container.backgroundColor = .white
    }
    
    func setup(text: String) {
        self.buttonLabel.text = text
//        if isHighlighted {
//            self.container.layer.borderColor = UIColor.alteaMainColor.cgColor
//            self.buttonLabel.textColor = .alteaMainColor
//        } else {
//            self.container.layer.borderColor = UIColor.systemGray.cgColor
//            self.buttonLabel.textColor = .systemGray
//        }
//        if isHighlighted {
//            self.container.layer.borderColor = UIColor.white.cgColor
//            self.buttonLabel.textColor = .white
//            self.container.backgroundColor = .alteaMainColor
//        } else {
//            self.container.layer.borderColor = UIColor.alteaMainColor.cgColor
//            self.buttonLabel.textColor = .alteaMainColor
//            self.container.backgroundColor = .white
//        }
    }
    
//    private func setTapped() {
//        self.container.addTapGestureRecognizer {
//            self.onTapped?()
//        }
//    }
}
