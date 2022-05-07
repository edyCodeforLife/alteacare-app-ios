//
//  AlteaPaymentWebviewVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 19/06/21.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import PanModal


class AlteaPaymentWebviewVC: UIViewController, WKUIDelegate, WKNavigationDelegate, AlteaPaymentVAView {
    
    private lazy var errorPaymentVC : ErrorPaymentVC = {
        let vc = ErrorPaymentVC()
        vc.delegate = self
        return vc
    }()
    
    var paymentUrl: String!
    var appointmentId: Int!
//    var paymentUrl: String!
    var checkStatusPaymentTappedPayed: ((Int) -> Void)?
    var viewModel: AlteaPaymentWebViewVM!
    var onBackTapped: (() -> Void)?

    @IBOutlet weak var alteaPaymentWV: WKWebView!
    @IBOutlet weak var buttonCheckStatus: UIButton!
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let requestStatus = BehaviorRelay<DetailAppointmentBody?>(value: nil)
    private let disposeBag = DisposeBag()
    
    let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
        self.showWebView(url: "\(paymentUrl ?? "")")
        self.setupActiveButton(button: buttonCheckStatus)
    }
    
    func showWebView(url : String){
        
        alteaPaymentWV.uiDelegate = self
        
        let replacedUrlByToken = url.replacingOccurrences(of: "{{REPLACE_THIS_TO_BEARER_USER}}", with: token)

        guard let url = URL(string: replacedUrlByToken) else {
            return
        }
        alteaPaymentWV.load(URLRequest(url: url))
//        alteaPaymentWV.allowsBackForwardNavigationGestures = true
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
       setUIDocumentMenuViewControllerSoureViewsIfNeeded(viewControllerToPresent)
       super.present(viewControllerToPresent, animated: flag, completion: completion)
     }

     func setUIDocumentMenuViewControllerSoureViewsIfNeeded(_ viewControllerToPresent: UIViewController) {
       if #available(iOS 13, *), viewControllerToPresent is UIDocumentMenuViewController && UIDevice.current.userInterfaceIdiom == .phone {
         // Prevent the app from crashing if the WKWebView decides to present a UIDocumentMenuViewController while it self is presented modally.
         viewControllerToPresent.popoverPresentationController?.sourceView = alteaPaymentWV
         viewControllerToPresent.popoverPresentationController?.sourceRect = CGRect(x: alteaPaymentWV.center.x, y: alteaPaymentWV.center.y, width: 1, height: 1)
       }
     }
        
    func setupNavigation(){
        self.setTextNavigation(title: "Pembayaran", navigator: .back, navigatorCallback: #selector(tapBackButton))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.white
    }
    
    @objc func tapBackButton() {
        self.onBackTapped?()
    }
    
    func bindViewModel() {
        let input = AlteaPaymentWebViewVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), statusRequestRelay: requestStatus.asObservable())
        let output = viewModel.transform(input)
        buttonCheckStatus.rx.tap
            .subscribe(onNext : { [unowned self] in
                self.requestStatus.accept(DetailAppointmentBody(appointment_id: appointmentId))
            }, onError: { _ in
            }).disposed(by: self.disposeBag)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.statusOutput.drive { (statusData) in
            if statusData?.status == "PAID" {
                self.checkStatusPaymentTappedPayed?(self.appointmentId)
            } else {
                self.presentPanModal(self.errorPaymentVC)
            }
        }.disposed(by: self.disposeBag)
    }
    
}


extension AlteaPaymentWebviewVC: ErrorPaymentDelegate {
    
    
    
}
