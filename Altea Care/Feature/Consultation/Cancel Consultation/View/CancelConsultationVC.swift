//
//  CancelConsultationVC.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import PanModal

class CancelConsultationVC: UIViewController, IndicatorInfoProvider, CancelConsultationView {
    
    var viewModel: CancelConsultationVM!
    var onConsultationTapped: ((CancelConsultationModel) -> Void)?
    
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private let filterModel = SelectionFilter.allCases
    private lazy var refreshControl = UIRefreshControl()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let filterRelay = BehaviorRelay<ListConsultationBody?>(value: nil)
    
    private var searchKey : String?
    private var sortBy : String?
    private var didSelectFromSortPicker: Bool = false
    
    private var model = [CancelConsultationModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var fullLoaded: Bool = false
    private var filter = ListConsultationBody(keyword: nil, sort: nil, sortType: "DESC", page: nil, startDate: nil, endDate: nil)
    
    private lazy var sortPicker: SortPickerVC = {
        let vc = SortPickerVC()
        vc.items = [VoteModel(title: "Paling Baru", isSelected: false, isUserSelectEnable: true),
                    VoteModel(title: "Paling Lama", isSelected: false, isUserSelectEnable: true)]
        vc.delegate = self
        return vc
    }()
    
    private lazy var filterByFamilyVC: FamilyMemberOptionVC = {
        let vc = FamilyMemberOptionVC()
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.setupSearchBar()
        self.bindViewModel()
        self.viewDidLoadRelay.accept(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        self.viewDidLoadRelay.accept(())
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
        //        self.view.setGradientBackground(color1: #colorLiteral(red: 0.8392156863, green: 0.9294117647, blue: 0.9647058824, alpha: 1), color2: #colorLiteral(red: 0.5294117647, green: 0.8039215686, blue: 0.9137254902, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let page = self.filter.page, page > 1 {
            self.filterRelay.accept(self.filter)
        } else if didSelectFromSortPicker {
            self.filterRelay.accept(self.filter)
        } else {
            self.viewDidLoadRelay.accept(())
        }
    }
    
    func bindViewModel() {
        let input = CancelConsultationVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), filterDay: filterRelay.asObservable())
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
        output.isFullyLoaded.drive { (isFullyLoaded) in
            self.fullLoaded = isFullyLoaded
        }.disposed(by: self.disposeBag)
        
        output.listMemberOutput.drive { (list) in
            self.filterByFamilyVC.listMember = list
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Dibatalkan")
    }
    
    private func setupSearchBar() {
        self.searchBar.onSortButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.presentPanModal(self.sortPicker)
        }
        
        self.searchBar.onFilterButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.presentPanModal(self.filterByFamilyVC)
        }
        
        searchBar.textField.rx.text
            .skip(2)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else { return }
                self.searchKey = value
                self.filter.keyword = self.searchKey
                self.filter.sortType = self.sortBy
                self.filterRelay.accept(self.filter)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        setupRefresh()
        searchBar.sortLabel.isHidden = true
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
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshAction() {
        self.filter.initialPage()
        self.viewDidLoadRelay.accept(())
    }
    
}

extension CancelConsultationVC: UITableViewDataSource {
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
            self.searchBarHeightConstraint.constant = 0
            cell.setupEmptyCell(page: "cancel")
            cell.selectionStyle = .none
            self.searchBar.isHidden = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OngoingConsultationCell", for: indexPath)  as! OngoingConsultationCell
            let target = self.model[indexPath.row]
            self.searchBarHeightConstraint.constant = 50
            self.searchBar.isHidden = false
            cell.setupCancelCosultation(model: target)
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

extension CancelConsultationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if model.count > 0 {
            let selectedCell = self.model[indexPath.row]
            self.onConsultationTapped?(selectedCell)
        }
    }
}

extension CancelConsultationVC: SortPickerDelegate {
    func priceSelected() {
        
    }
    
    func experienceSelected() {
        
    }
    
    func priceHighLow() {
        
    }
    
    func priceLowHigh() {
        
    }
    
    func experienceOldestNewest() {
        
    }
    
    func experienceNewestOldest() {
        
    }
    
    func popularitySelected() {
        sortBy = ""
        self.filter.keyword = searchKey
        self.filter.sortType = sortBy
        self.filterRelay.accept(self.filter)
    }
    
    func didSelect(_ picker: SortPickerVC, index: Int) {
        self.didSelectFromSortPicker = true
        switch index {
        case 0:
            self.descendingSelected()
            break
        case 1:
            self.ascendingSelected()
            break
        default:
            break
        }
    }
    
    private func ascendingSelected() {
        sortBy = "ASC"
        self.model.removeAll()
        self.filter.initialPage()
        self.filter.keyword = searchKey
        self.filter.sortType = sortBy
    }
    
    private func descendingSelected() {
        sortBy = "DESC"
        self.model.removeAll()
        self.filter.initialPage()
        self.filter.keyword = searchKey
        self.filter.sortType = sortBy
    }
}

extension CancelConsultationVC: FilterMemberDelegate{
    func memberChoosed(idMember: String, isMainProfile: Bool) {
        if isMainProfile{
            self.filter.patientId = nil
        }else{
            self.filter.patientId = idMember
        }
        self.filterRelay.accept(self.filter)
    }
}
