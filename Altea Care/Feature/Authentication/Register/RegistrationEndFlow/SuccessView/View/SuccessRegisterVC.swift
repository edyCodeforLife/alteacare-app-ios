//
//  SuccessRegister.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 03/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class SuccessRegisterVC: UIViewController, SuccessRegisterView{
   
    var viewModel: SuccessRegisterVM!
    var goToLogin: (() -> Void)?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iv: UIImageView!
    let gradientLayer = CAGradientLayer()
    
    var timer : Timer?
    var totalTime = 1
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModel()
        self.setupView()
        self.setupNavigation()
        
        self.viewDidLoadRelay.accept(())
    }
    
    func setupView(){
        let imageView = UIImageView()
        imageView.image =  #imageLiteral(resourceName: "iconSuccessRegister")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
        view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Selamat Regisrasi Berhasil"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
 
    }
    
    func bindViewModel() {
//        self.startTime()
        
        let input = SuccessRegisterVM.Input(didLoadRelay: viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.model.drive { (userData) in
            self.setupTracker(userId: userData?.id)
            Preference.removeString(forKey: .UserEmail)
            Preference.removeString(forKey: .UserPhone)
            self.goToLogin?()
        }.disposed(by: self.disposeBag)
    }
    
    func setupUI(){
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
    }
    
    func startTime(){
        self.totalTime = 5
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            if let timer = self.timer{
                self.stopTimer()
                self.timer = nil
            }
            self.goToLogin?()
        }
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
    }
    
    func setupNavigation(){
        self.setTextNavigation(title: "", navigator: .none)
    }
}

//MARK: - Setup Tracker
extension SuccessRegisterVC {
    
    func setupTracker(userId: String?) {
        let date = UserDefaults.standard.string(forKey: "Date")
        let gender = UserDefaults.standard.string(forKey: "gender")
        let city = UserDefaults.standard.string(forKey: "city")
        let firstName = UserDefaults.standard.string(forKey: "firstname")
        let lastName = UserDefaults.standard.string(forKey: "lastname")
        let email = Preference.getString(forKey: .UserEmail)
        let phone = Preference.getString(forKey: .UserPhone)
        
        self.track(.registration(AnalyticsRegistration(userId: userId, name: "\(firstName ?? "") \(lastName ?? "")", gender: gender, email: email, phone: phone, city: city, signupMethod: "email/phone_number", userDob: date)))
    }
}
