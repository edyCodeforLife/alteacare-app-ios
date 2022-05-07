//
//  PaymentMethodVC.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import MidtransKit

class PaymentMethodVC: UIViewController, PaymentMethodView {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PaymentMethodVM!
    var consultationId: Int!
    var voucherCode: VoucherBody?
    var goToWebView: ((String, Int) -> Void)?
    var goToReview: ((Int) -> Void)?
//    var paymentUrl : String!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let selectedRelay = BehaviorRelay<PaymentMethodModelItem?>(value: nil)
    private lazy var refreshControl = UIRefreshControl()
    
    private var model = [PaymentMethodModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupTableView()
        self.bindViewModel()
        self.viewDidLoadRelay.accept(())
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
    }
    
    func setupNavigation() {
        self.setTextNavigation(title: "Metode Pembayaran", navigator: .back)
    }
    
    func bindViewModel() {
        let input = PaymentMethodVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), selectedPayment: selectedRelay.asObservable(), idConsultation: consultationId, voucherBody: voucherCode)
        
        let output = viewModel.transform(input)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        
        output.paymentList.drive { (list) in
            self.model = list
        }.disposed(by: self.disposeBag)
        
        output.paymentSelected.drive { (model) in
            if model?.type == "ALTEA_PAYMENT_WEBVIEW"{
                self.goToWebView?(model?.paymentUrl ?? "", self.consultationId)
            } else {
                guard let token = model?.token else {return}
                self.requestTransactionTokenMidtrans(token: token)
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        self.setupRefresh()
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshAction() {
        self.viewDidLoadRelay.accept(())
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNIB(with: PaymentMethodItemCell.self)
    }
    
    private func configCell(cell: PaymentMethodItemCell, data: PaymentMethodModelItem) {
        cell.nameL.text = data.name
        cell.descL.text = data.desc
        
        if let url = URL(string: data.icon) {
            cell.methodIV.kf.setImage(with: url)
        }
    }
    
    private func requestTransactionTokenMidtrans(token: String){
        MidtransMerchantClient.shared().requestTransacation(withCurrentToken: token){ [weak self] midtransToken, err in
            if let error = err {
                print(error)
            }
            guard let midtransToken =  midtransToken else {return}
            let vc = MidtransUIPaymentViewController.init(token: midtransToken)
            vc?.paymentDelegate = self
            self?.present(vc!, animated: true, completion: nil)
        }
    }
}

extension PaymentMethodVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].paymentMethod.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        let label = UILabel()
        label.frame = CGRect.init(x: 18, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = model[section].type
        label.font = UIFont.font(size: 14, fontType: .normal)
        label.textColor = .alteaDark1
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: PaymentMethodItemCell.self) else {
            return UITableViewCell()
        }
        let data = model[indexPath.section].paymentMethod[indexPath.row]
        configCell(cell: cell, data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.model[indexPath.section].paymentMethod[indexPath.row]
        self.selectedRelay.accept(item)
    }
}

extension PaymentMethodVC: MidtransUIPaymentViewControllerDelegate  {
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, save result: MidtransMaskedCreditCard!) {
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, saveCardFailed error: Error!) {
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentDeny result: MidtransTransactionResult!){
        
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
        self.goToReview?(consultationId)
//        navigationController?.popToRootViewController(animated: true)
    }
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
    }
    
    func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
    }
    
}
