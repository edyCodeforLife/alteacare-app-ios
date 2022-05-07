//
//  OngoingConsultationVC.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class OngoingConsultationVC: UIViewController, IndicatorInfoProvider, OngoingConsultationView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: OngoingConsultationVM!
    var onConsultationTapped: ((OngoingConsultationModel) -> Void)?
    var onConsultationCallingTapped: ((Int, String?, Bool) -> Void)?
    var onPaymentTapped: ((String, Int) -> Void)?
    var onPaymentMethod: ((String) -> Void)?
    var onOutsideOperatingHour: ((SettingModel) -> Void)?

    private var filterModel = SelectionFilterModel.basic
    private lazy var refreshControl = UIRefreshControl()
    private var fullLoaded: Bool = false
    private var filter = ListConsultationBody(keyword: nil, sort: nil, sortType: "DESC", page: 1, startDate: Date().toStringDefault(), endDate: Date().toStringDefault())
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let filterRelay = BehaviorRelay<ListConsultationBody?>(value: nil)
    private var familyRelations = [MemberModel]()
    private var setting: SettingModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var model = [OngoingConsultationModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var filterByFamilyVC: FamilyMemberOptionVC = {
        let vc = FamilyMemberOptionVC()
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollectionView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let page = self.filter.page, page > 1 {
            self.filterRelay.accept(self.filter)
        } else {
            self.viewDidLoadRelay.accept(())
        }
    }
    
    func bindViewModel() {
        let input = OngoingConsultationVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), filterDay: filterRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.consultationList.drive { (list) in
            self.model = list
        }.disposed(by: self.disposeBag)
        output.consultationMutableList.drive { (list) in
            self.model.append(contentsOf: list)
        }.disposed(by: self.disposeBag)
        output.settingOutput.drive{ result in
            self.setting = result
        }.disposed(by: disposeBag)
        output.listMemberOutput.drive { (list) in
            self.filterByFamilyVC.listMember = list
            self.familyRelations = list
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Berjalan")
    }
    
    private func setupUI() {
        self.setupRefresh()
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10)
        let nib = UINib(nibName: "FilterButtonCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "FilterButtonCollectionViewCell")
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "OngoingConsultationCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "OngoingConsultationCell")
        let emptyNib = UINib(nibName: "EmptyStateCell", bundle: nil)
        self.tableView.register(emptyNib, forCellReuseIdentifier: "EmptyStateCell")
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 49, right: 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    private func getDayOngoing() -> [String]{
        var data = [String]()
        data.append("Hari Ini")
        data.append("Minggu Ini")
        data.append("Hari Lain")
        return data
    }
    
    func familyRelation(idPatient: String)-> String?{
        if let foo = familyRelations.first(where: {$0.idMember == idPatient}) {
            return foo.role
        }
        return "Pribadi"
    }
    @objc private func refreshAction() {
        self.filter.initialPage()
        self.viewDidLoadRelay.accept(())
    }
    
    @IBAction func filterByPatient(_ sender: Any) {
        self.presentPanModal(self.filterByFamilyVC)
    }
}

extension OngoingConsultationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.count == 0 {
            return 1
        } else {
            return model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCell", for: indexPath)  as! EmptyStateCell
            cell.setupEmptyCell(page: "ongoing")
            cell.selectionStyle = .none
            cell.isHighlighted = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OngoingConsultationCell", for: indexPath)  as! OngoingConsultationCell
            let target = self.model[indexPath.row]
            cell.setupOngoingCosultation(model: target)
            if let settingData = setting {
                cell.setupSettingCallMA(setting: settingData)
            }
            cell.selectionStyle = .none
            cell.isHighlighted = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.model.count - 4
        if indexPath.row == lastElement && !self.fullLoaded {
            self.filter.nextPage()
            self.filterRelay.accept(self.filter)
            self.fullLoaded = true
        }
    }
}

extension OngoingConsultationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if model.count > 0 {
            let consultation = self.model[indexPath.row]
            let id = Int(consultation.id) ?? 0
            let code = consultation.orderCode
            switch consultation.statusDetail {
            case "Belum terverifikasi", "Order baru":
                openCosultation(id: id , code: code, isMA: true)
            case "Menunggu Konsultasi", "Memo altea diproses", "Temui Dokter":
                self.onConsultationTapped?(consultation)
            case "Sedang Berlangsung":
                openCosultation(id: id, code: code, isMA: false)
            case "Menunggu pembayaran":
                openPayment(consultation: consultation)
            default: break
            }
        }
    }
    
    private func openPayment(consultation: OngoingConsultationModel) {
        let paymentUrl = consultation.transaction?.paymentUrl ?? ""
        let refId = consultation.transaction?.refId ?? ""
        let appointmentId = consultation.id.toInt()
        if !paymentUrl.isEmpty && !refId.isEmpty {
            self.onPaymentTapped?(paymentUrl, appointmentId)
        } else {
            self.onPaymentMethod?(consultation.id)
        }
    }
    
    private func openCosultation(id: Int, code: String, isMA: Bool) {
        switch isMA {
        case true:
            if let settingData = self.setting {
                if settingData.isInOfficeHour() {
                    self.onConsultationCallingTapped?(id, code, isMA)
                } else {
                    onOutsideOperatingHour?(settingData)
                }
            }
            
        case false:
            self.onConsultationCallingTapped?(id, code, isMA)
            
        }
    }
}

extension OngoingConsultationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getDayOngoing().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterButtonCollectionViewCell", for: indexPath) as! FilterButtonCollectionViewCell
        let target = self.getDayOngoing()[indexPath.row]
        if cell.isSelected { }
        cell.setup(text: target)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        }
    }
    
}

extension OngoingConsultationVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let thisWeek = Date().getThisWeek()
        let nextDay = Date().getNextDay()
        let nextWeek = Date().getNextWeek()
        let nextMonth = Date().getNextMonth()
        
        let arrWeekDates = Date().getWeekDates()
        let dateFormat = "yyyy-MM-dd"
        let nextMonday = arrWeekDates.nextWeek.first!.toDate(format: dateFormat)
        
        if indexPath.row == 0 {
            let today = Date().toStringDefault()
            self.filter.startDate = today
            self.filter.endDate = today
            self.model.removeAll()
            self.filterRelay.accept(self.filter)
            self.viewDidLoadRelay.accept(())
        } else if indexPath.row == 1 {
            self.filter.startDate = nextDay
            self.filter.endDate = thisWeek.1
            self.model.removeAll()
            self.filterRelay.accept(self.filter)
            self.viewDidLoadRelay.accept(())
        } else if indexPath.row == 2 {
            self.filter.startDate = nextMonday
            self.filter.endDate = nextMonth
            self.model.removeAll()
            self.filterRelay.accept(self.filter)
            self.viewDidLoadRelay.accept(())
        }
    }
}

extension OngoingConsultationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.font = .font(size: 13, fontType: .normal)
        label.text = self.getDayOngoing()[indexPath.row]
        label.sizeToFit()
        let constraint = 28.0
        let cellWidth = label.frame.width + constraint
        return CGSize(width: cellWidth, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}

extension OngoingConsultationVC: FilterMemberDelegate{
    func memberChoosed(idMember: String, isMainProfile: Bool) {
        self.model.removeAll()
        if isMainProfile{
            self.filter.patientId = nil
        }else{
            self.filter.patientId = idMember
        }
        self.filterRelay.accept(self.filter)
    }
}
