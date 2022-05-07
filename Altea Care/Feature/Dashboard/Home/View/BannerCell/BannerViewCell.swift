//
//  BannerViewCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 24/09/21.
//

import UIKit

class BannerViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
    }

}
