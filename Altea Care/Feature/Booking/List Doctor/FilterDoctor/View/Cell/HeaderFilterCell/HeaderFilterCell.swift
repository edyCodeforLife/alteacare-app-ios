//
//  HeaderFilterCell.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 20/12/21.
//

import UIKit

class HeaderFilterCell: UITableViewCell {
    
    var onShowAllTapped: (() -> Void)?

    @IBOutlet weak var titleLable: ACLabel!
    @IBOutlet weak var seeAllButton: CircleButtonBackground!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var widthButton: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupMargin(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.topMargin.constant = top
        self.bottomMargin.constant = bottom
        self.leadingMargin.constant = leading
        self.trailingMargin.constant = trailing
    }
    
    func setupCell(title: String, style: CircleButtonBackground.Style, sizeFont: CGFloat, fontType: FontStyle) {
        self.titleLable.text = title
        self.titleLable.setupCustomFont(size: 14, fontType: .weight700)
        
        self.seeAllButton.titleButton.text = style.title
        self.seeAllButton.setupButton(style: style, sizeFont: sizeFont, fontType: fontType)
        self.widthButton.constant = UILabel.textWidth(label: self.seeAllButton.titleButton, text: style.title)
    }
    
    func isHideTrailingView(isHidden: Bool) {
        self.seeAllButton.isHidden = isHidden
    }
    
    private func setupAction() {
        self.seeAllButton.addTapGestureRecognizer {
            self.onShowAllTapped?()
        }
    }
        
}
