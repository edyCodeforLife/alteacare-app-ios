//
//  ChatHistoryCell.swift
//  Altea Care
//
//  Created by Hedy on 17/3/21.
//

import UIKit

class ChatHistoryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: ACLabel!
    @IBOutlet weak var message: ACLabel!
    @IBOutlet weak var date: ACLabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var counter: ACLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.icon.image = #imageLiteral(resourceName: "Chat")
        self.icon.layer.cornerRadius = self.icon.bounds.height/2
        self.icon.clipsToBounds = true
        
        self.title.textColor = .alteaDark1
        self.message.textColor = .alteaDark4
        self.date.textColor = .alteaDark4
        self.line.backgroundColor = .alteaLight1
        
        self.counter.textColor = .white
        self.counter.backgroundColor = #colorLiteral(red: 1, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        self.counter.layer.masksToBounds = true
        self.counter.layer.cornerRadius = self.counter.layer.bounds.height / 2
    }
    
    func setCell(model: ChatHistoryModel) {
        self.title.text = model.title
        self.message.text = model.message
        self.date.text = model.date
        if model.counter == 0 || model.counter == nil {
            self.counter.isHidden = true
        } else if model.counter! >= 100 {
            self.counter.font = .font(size: 10, fontType: .bold)
            self.counter.isHidden = false
            self.counter.text = "99+"
        } else {
            self.counter.font = .font(size: 13, fontType: .bold)
            self.counter.isHidden = false
            self.counter.text = "\(model.counter ?? 1)"
        }
    }
    
}
