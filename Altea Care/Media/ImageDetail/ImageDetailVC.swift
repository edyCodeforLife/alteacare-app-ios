//
//  ImageDetailVC.swift
//  Altea Care
//
//  Created by Tiara on 24/03/21.
//

import UIKit

class ImageDetailVC: UIViewController {

    @IBOutlet weak var detailImageIV: UIImageView!
    var image: UIImage?
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        detailImageIV.image = image
    }


    @IBAction func closeTapped(_ sender: Any) {
        
    }
}
