//
//  MedicalResumeVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class MedicalResumeVC: UIViewController, IndicatorInfoProvider, MedicalResumeView {
    
    var viewModel: MedicalResumeVM!
    var id: String!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: ACButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    
    private let disposeBag = DisposeBag()
    private let idRelay = BehaviorRelay<String?>(value: nil)
    private lazy var refreshControl = UIRefreshControl()
    
    private var model = [MedicalResumeModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var emptyModel = [EmptyDocumentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupRefresh()
        self.bindViewModel()
        self.idRelay.accept(self.id)
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
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
        let input = MedicalResumeVM.Input(fetch: self.idRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.data.drive { (model) in
            self.model = model
            self.setupTracker()
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Catatan Dokter")
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "MedicalResumeCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MedicalResumeCell")
        let emptyNib = UINib(nibName: "DocumentEmptyTableViewCell", bundle: nil)
        self.tableView.register(emptyNib, forCellReuseIdentifier: "DocumentEmptyTableViewCell")
    }
    
    private func setupEmptyState() {
        self.button.set(type: .bordered(custom: .alteaMainColor), title: "Hubungin Medical Advisor", titlePosition: .center, icon: #imageLiteral(resourceName: "greenconversation"), iconPosition: .left)
        self.button.onTapped = { [weak self] in
            guard let self = self else { return }
//            ChatManager.shared.show(self, identity: "", uniqueRoom: "", roomName: "")
        }
    }
    
}

extension MedicalResumeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model.count == 1  {
            return 1
        } else {
            return self.model.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.model.count == 1 {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "DocumentEmptyTableViewCell", for: indexPath) as! DocumentEmptyTableViewCell
            emptyCell.buttonTapped = {
                self.idRelay.accept(self.id)
            }
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalResumeCell", for: indexPath) as! MedicalResumeCell
            let target = self.model[indexPath.row]
            cell.setValueText(model: target, isLast: indexPath.row == (self.model.count - 1))
            return cell
        }
    }
    
    
}

extension MedicalResumeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Setup Tracker
extension MedicalResumeVC {
    
    func setupTracker() {
        let diagnosis = self.model.filter { $0.title == "Diagnosis" }.first?.textViewText
        let keluhan = self.model.filter { $0.title == "Keluhan" }.first?.textViewText
        let resepObat = self.model.filter { $0.title == "Resep Obat" }.first?.textViewText
        let rekomendasiDokter = self.model.filter { $0.title == "Pemeriksaan Penunjang" }.first?.textViewText
        let catatanLain = self.model.filter { $0.title == "Catatan" }.first?.textViewText
        
        self.track(.medicalMoeNotes(AnalyticsMoeMedicalNotes(diagnosis: diagnosis, keluhan: keluhan, resepObat: resepObat, rekomendasiDokter: rekomendasiDokter, catatanLain: catatanLain)))
        self.track(.medicalOtherNotes)
        self.defaultAnalyticsService.trackUserAttribute(diagnosis, key: AnalyticsCustomAttributes.lastDiagnosedDisease.rawValue)
    }
}
