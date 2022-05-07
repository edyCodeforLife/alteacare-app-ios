//
//  ReceiptVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class ReceiptVC: UIViewController, IndicatorInfoProvider, ReceiptView {

    var viewModel: ReceiptVM!
    var id: String!
    
    private let disposeBag = DisposeBag()
    private let idRelay = BehaviorRelay<String?>(value: nil)
    private lazy var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var grandTotalLabel: ACLabel!
    @IBOutlet weak var grandTotal: ACLabel!
    @IBOutlet weak var rewardPoint: ACLabel!
    @IBOutlet weak var rewardPointView: UIView!
    @IBOutlet weak var rewardPointConstraint: NSLayoutConstraint!
    
    private var model: [ReceiptModelDetail] = [ReceiptModelDetail]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI(total: nil)
        self.setupTableView()
        self.setupRefresh()
        self.bindViewModel()
        self.idRelay.accept(self.id)
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshAction() {
        self.idRelay.accept(self.id)
    }

    func bindViewModel() {
        let input = ReceiptVM.Input(fetch: self.idRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.data.drive { (model) in
            guard let model = model else { return }
            self.model = model.item
            self.setupUI(total: model.totalPrice)
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Biaya")
    }
    
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "SectionCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SectionCell")
        let nib1 = UINib(nibName: "ReceiptConsultationCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "ReceiptConsultationCell")
        let nib2 = UINib(nibName: "ReceiptMedicinesCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "ReceiptMedicinesCell")
        let nib3 = UINib(nibName: "ReceiptDeliveryAddressCell", bundle: nil)
        self.tableView.register(nib3, forCellReuseIdentifier: "ReceiptDeliveryAddressCell")
        let nib4 = UINib(nibName: "ReceiptPaymentTableViewCell", bundle: nil)
        self.tableView.register(nib4, forCellReuseIdentifier: "ReceiptPaymentTableViewCell")
    }
    
    private func setupUI(total: String?) {
        self.grandTotalLabel.font = .font(size: 16, fontType: .bold)
        self.grandTotal.font = .font(size: 16, fontType: .bold)
        self.grandTotal.text = "\(total ?? "")"
        
//        self.rewardPoint.font = .font(size: 14, fontType: .bold)
//        self.rewardPoint.text = "Reward Poin +\(reward ?? "") Poin"
    }
}



extension ReceiptVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.model[indexPath.section].contents[indexPath.row] {
        case .consultation(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptConsultationCell") as! ReceiptConsultationCell
            cell.setCell(model: model)
            return cell
        case .medicines(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptMedicinesCell") as! ReceiptMedicinesCell
            cell.setCell(model: model)
            return cell
            
        case .delivery(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptDeliveryAddressCell") as! ReceiptDeliveryAddressCell
            cell.setCell(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.model[indexPath.section].contents[indexPath.row] {
        case .consultation(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptConsultationCell") as! ReceiptConsultationCell
            cell.setCell(model: model)
            return CGFloat(214 + (model.fees.count * 20))
        default:
            return UITableView.automaticDimension
        }
    }
    
}

extension ReceiptVC: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.model[section].title
//    }
}
