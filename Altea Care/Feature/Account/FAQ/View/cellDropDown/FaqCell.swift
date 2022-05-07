//
//  MCDropCell.swift
//  LoyaltyApp
//
//  Created by Arif Rahman Sidik on 02/03/21.
//

import Foundation
import UIKit

class FaqCell : UITableViewCell{
    var data : FaqModel? {
        didSet {
            guard let data = data else { return }
            self.questionLabel.text = data.question
            self.answerLabel.attributedText = data.answer.htmlAttributedString()
            self.answerLabel.font = UIFont(name: "Inter-Regular", size: 12)
        }
    }
    
    func animate(){
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    fileprivate let imageViewChevron : UIImageView = {
       let chevron = UIImageView()
        chevron.image = #imageLiteral(resourceName: "DownChevronAltea")
        chevron.clipsToBounds = true
        chevron.translatesAutoresizingMaskIntoConstraints = true
        return chevron
    }()
    
    fileprivate let questionLabel : UILabel =  {
        let label = UILabel()
        label.text = "text"
        label.font = UIFont(name: "Inter-Bold", size: 13)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate let answerLabel : UILabel =  {
        let label = UILabel()
        label.text = "answer"
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate let container : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.2
        container.layer.shadowColor = UIColor.black.cgColor
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        
        container.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        
        container.addSubview(questionLabel)
        container.addSubview(answerLabel)
        
        questionLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -4).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
        answerLabel.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        addSubview(imageViewChevron)
        imageViewChevron.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        imageViewChevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 5).isActive = true
        imageViewChevron.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 5).isActive = true
        imageViewChevron.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
}
