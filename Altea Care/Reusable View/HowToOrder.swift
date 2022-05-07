//
//  HowToOrder.swift
//  Altea Care
//
//  Created by Admin on 5/4/21.
//

import UIKit

class HowToOrder: UIViewController {

    @IBOutlet weak var popUpContainer: UIView!
    @IBOutlet weak var confirmationButton: ACButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dismissButton()
    }
    
    private func setupUI() {
        self.popUpContainer.layer.cornerRadius = 8
        self.confirmationButton.set(type: .filled(custom: .alteaMainColor), title: "Ya, Saya Mengerti")
    }
    
    private func dismissButton() {
        self.confirmationButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK: - Setup Tracker
extension HowToOrder {
    
    func setupTracker() {
        self.track(.transactionDone(AnalyticsTransactionDone(sessionStatus: nil)))
    }
}
