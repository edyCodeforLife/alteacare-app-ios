//
//  RegisterReviewVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterReviewVC: UIViewController, RegisterReviewView {
    
    var goToChangeAddressEmail: (() -> Void)?

    var viewModelRegisterReview: RegisterReviewVM!
    var goToContactField: (() -> Void)?
    
    var modelTemp : RegisterBody?
    
    @IBOutlet weak var labelInstruction: UILabel!
    @IBOutlet weak var labelFirstname: UILabel!
    @IBOutlet weak var labelGetFirstname: UILabel!
    @IBOutlet weak var labelBirthdate: UILabel!
    @IBOutlet weak var labelGetBirthdate: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelGetGender: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonChangeData: UIButton!
    @IBOutlet weak var labelCityAndCountry: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupActiveButton(button: buttonSubmit)
        self.setupSecondaryButton(button: buttonChangeData)
        self.setupNavigation()
        self.setupData()
        
    }
    
    func setupData(){
        self.labelGetFirstname.text = "\(UserDefaults.standard.string(forKey: "firstname") ?? "")"+" \( UserDefaults.standard.string(forKey: "lastname") ?? "")"
        self.labelGetBirthdate.text = "\(UserDefaults.standard.string(forKey: "Date") ?? "")"
        self.labelGetGender.text = SexFormatter.formatted("\( UserDefaults.standard.string(forKey: "gender") ?? "")")
        self.labelCityAndCountry.text = "\(UserDefaults.standard.string(forKey: "country") ?? ""), \(UserDefaults.standard.string(forKey: "city") ?? "")"
    }
    
    func bindViewModel() {
        let input = RegisterReviewVM.Input()
        let output = viewModelRegisterReview.transform(input)
        output.state.drive(self.rx.state).disposed(by: disposeBag)
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        self.goToContactField?()
    }
    
    @IBAction func buttonChangeDataPersonalTapped(_ sender: Any) {
        self.goToChangeAddressEmail?()
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Rincian Data Pribadi", navigator: .none)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
