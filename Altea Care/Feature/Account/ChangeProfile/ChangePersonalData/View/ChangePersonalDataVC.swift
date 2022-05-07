//
//  ChangePersonalDataVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePersonalDataVC: UIViewController, ChangePersonalDataView {
    
    var onButtonCallTapped: (() -> Void)?
    var viewModel: ChangePersonalDataVM!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var iconDoc: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonCall: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
//        self.setupActiveButton(button: buttonCall)
    }
    
    
    func bindViewModel() {
    }
    
    @IBAction func buttonGoToContactUs(_ sender: Any) {
        self.onButtonCallTapped?()
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Ubah Personal Data", navigator: .none)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
