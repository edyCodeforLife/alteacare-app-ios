//
//  ForceUpdateVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 14/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class ForceUpdateVC: UIViewController, ForceUpdateView {
    
    var viewModel: ForceUpdateVM!
    var goToAppStore: (() -> Void)?

    @IBOutlet weak var buttonUpdate: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    static let URLApps = "https://apps.apple.com/us/app/alteacare/id1571455658"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActiveButton(button: buttonUpdate)
        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/id/app/alteacare/id1571455658") {
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
               // Earlier versions
               if UIApplication.shared.canOpenURL(url as URL) {
                  UIApplication.shared.openURL(url as URL)
               }
           }
        }
    }
}
