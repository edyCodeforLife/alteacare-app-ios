//
//  FilterDoctorVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 16/09/21.
// select parent tags dari filter vc tidak ckelis semua di halaman find filter
// coba pilih child dari filter vc lalu ke find filter

import UIKit
import PanModal
import RxSwift
import RxCocoa


class FilterDoctorVC: UIViewController, FilterDoctorView {

    var viewModel: FilterDoctorVM!
    var daysData: [DayName]!
    var specializationsData: [ListSpecialistModel]!
    var hospitalsData: [ListHospitalModel]!
    var doctorsData: [ListDoctorModel]!
    var pricesData: [ListPrice]!
    var daySelected: FilterList!
    var tagSelected: [FilterList]!
    var onShowAllTapped: ((TypeTagCollection, FilterList, [FilterList]) -> Void)?
    var onFilterTapped: ((FilterList, [FilterList]) -> Void)?
    
    @IBOutlet weak var onSwipeView: UIView!
    @IBOutlet weak var resetButton: CircleButtonBackground!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: ACButton!
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let idSpecializationRelay = BehaviorRelay<String?>(value: nil)
    private let requestSpecializationsRelay = BehaviorRelay<SpecializationsRequest?>(value: nil)
    private let requestDoctorsRelay = BehaviorRelay<DoctorsSpecializationBody?>(value: nil)
    
    private var isResetTapped: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupUI()
        self.setupAction()
//        print("hasilnya adalah \(tagSelected) \n\n\n\n\n\n\n")
//        print("hasilnya adalah \(hospitals) \n\n\n\n\n\n\n")
//        print("hasilnya adalah \(doctors) \n\n\n\n\n\n\n")
    }
    
    func bindViewModel() {
        let input = FilterDoctorVM.Input()
        
        let output = viewModel.transform(input)
        disposeBag.insert([
            output.state.drive(self.rx.state),
            output.state.drive { (_) in
                //self.refreshControl.endRefreshing()
            },
        ])
    }
    
    private func setupAction() {
        self.applyButton.onTapped = { [weak self] in
            guard let self = self else { return }
//            print("note irfan : FilterDoctorVC applyButton \(self.daySelected)")
//            print("")
//            print("")
//            print("note irfan : FilterDoctorVC applyButton \(self.tagSelected)")
//            print("")
//            print("")
            self.onFilterTapped?(self.daySelected, self.tagSelected)
        }
        
        
        self.resetButton.addTapGestureRecognizer {
            self.isResetTapped = true
            self.tagSelected.removeAll()
            self.daySelected = FilterList(id: "", name: "", isChecked: false, isOpen: false, typeTag: .days, subFilter: [])
            
            self.tableView.reloadRows(at: [IndexPath(item: 1, section: 0),
                                           IndexPath(item: 3, section: 0),
                                           IndexPath(item: 5, section: 0),
                                           IndexPath(item: 7, section: 0)], with: .automatic)
        }
    }
    
    private func setupUI() {
        
        func setupTableView() {
            let nib = UINib(nibName: "HeaderFilterCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "HeaderFilterCell")
            
            let nibTag = UINib(nibName: "TagCollectionFilterCell", bundle: nil)
            self.tableView.register(nibTag, forCellReuseIdentifier: "TagCollectionFilterCell")
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
        func setupButtonView() {
            self.resetButton.setupButton(style: .fill(title: "Atur Ulang", color: "3E8CB9", background: "D6EDF6", radius: self.resetButton.bounds.height / 2), sizeFont: 14, fontType: .weight700)
            
            self.applyButton.set(type: .filled(custom: .alteaMainColor), title: "Terapkan")
            self.applyButton.layer.cornerRadius = 8

        }
        func setupSwipeView() {
            self.onSwipeView.layer.cornerRadius = 4
        }
        
        setupSwipeView()
        setupButtonView()
        setupTableView()
    }
    
    func checkTypeTag(index: Int) -> TypeTagCollection {
        if index == 1 {
            return .days
        } else if index == 3 {
            return .specializations
        } else if index == 5 {
            return .hospitals
        } else if index == 7 {
            return .prices
        } else {
            return .empty
        }
    }
    
}

extension FilterDoctorVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row.isMultiple(of: 2) {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderFilterCell", for: indexPath) as! HeaderFilterCell
            headerCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                headerCell.setupCell(title: "Hari", style: .clear(title: "Lihat Semua", color: "61C7B5"), sizeFont: 14, fontType: .weight700)
                headerCell.isHideTrailingView(isHidden: true)
            }
            
            if indexPath.row == 2 {
                headerCell.setupCell(title: "Dokter Spesialis", style: .clear(title: "Lihat Semua", color: "61C7B5"), sizeFont: 14, fontType: .weight700)
                headerCell.onShowAllTapped = {
                    self.onShowAllTapped?(.specializations, self.daySelected, self.tagSelected)
                }
            }
            if indexPath.row == 4 {
                headerCell.setupCell(title: "Rumah Sakit", style: .clear(title: "Lihat Semua", color: "61C7B5"), sizeFont: 14, fontType: .weight700)
                headerCell.onShowAllTapped = {
                    self.onShowAllTapped?(.hospitals, self.daySelected, self.tagSelected)
                }
            }
            if indexPath.row == 6 {
                headerCell.setupCell(title: "Harga", style: .clear(title: "Lihat Semua", color: "61C7B5"), sizeFont: 14, fontType: .weight700)
                headerCell.isHideTrailingView(isHidden: true)
            }
            return headerCell
        } else {
            let bodyCell = tableView.dequeueReusableCell(withIdentifier: "TagCollectionFilterCell", for: indexPath) as! TagCollectionFilterCell
            bodyCell.selectionStyle = .none
            
            if self.isResetTapped {
                if indexPath.row == 1 {
                    bodyCell.resetCell(typeTagSelected: .days)
                    bodyCell.setupDays(daySelected: self.daySelected, daysData: self.daysData)
                }
                if indexPath.row == 3 {
                    bodyCell.resetCell(typeTagSelected: .specializations)
                    bodyCell.setupSpecializations(tagSelected: self.tagSelected, specializationsData: self.specializationsData)
                }
                
                if indexPath.row == 5 {
                    bodyCell.resetCell(typeTagSelected: .hospitals)
                    bodyCell.setupHospitals(tagSelected: self.tagSelected, hospitalsData: self.hospitalsData)
                }
                
                if indexPath.row == 7 {
                    bodyCell.resetCell(typeTagSelected: .prices)
                    bodyCell.setupPrices(tagSelected: self.tagSelected, pricesData: self.pricesData)
                    
                    self.isResetTapped = false
                }
            } else {
                if indexPath.row == 1 {
                    bodyCell.setupDays(daySelected: self.daySelected, daysData: self.daysData)
                }
                if indexPath.row == 3 {
                    bodyCell.setupSpecializations(tagSelected: self.tagSelected, specializationsData: self.specializationsData)
                }
                
                if indexPath.row == 5 {
                    bodyCell.setupHospitals(tagSelected: self.tagSelected, hospitalsData: self.hospitalsData)
                }
                
                if indexPath.row == 7 {
                    bodyCell.setupPrices(tagSelected: self.tagSelected, pricesData: self.pricesData)
                }
            }
            
            bodyCell.onTagSelected = { [weak self] data in
                guard let self = self else { return }
                switch data.send {
                case .days(let currentTag, let isSelected):
                    self.daySelected = FilterList(
                        id: isSelected ? currentTag.id : "",
                        name: isSelected ? currentTag.name : "",
                        isChecked: isSelected,
                        isOpen: false,
                        typeTag: .days,
                        subFilter: [])
                case .specializations(let currentTag, let isSelected):
                    if isSelected {
                        self.tagSelected.append(FilterList(
                            id: currentTag.id,
                            name: currentTag.name,
                            isChecked: true,
                            isOpen: true,
                            typeTag: .specializations,
                            subFilter: []))
                    } else {
                        for (indexCurrentTag, valueCurrentTag) in self.tagSelected.enumerated() {
                            if valueCurrentTag.typeTag == .specializations && valueCurrentTag.name.lowercased() == currentTag.name.lowercased() {
                                self.tagSelected.remove(at: indexCurrentTag)
                            }
                        }
                    }
                case .hospitals(let currentTag, let isSelected):
                    if isSelected {
                        self.tagSelected.append(FilterList(
                            id: currentTag.id,
                            name: currentTag.name,
                            isChecked: true,
                            isOpen: true,
                            typeTag: .hospitals,
                            subFilter: []))
                    } else {
                        for (indexCurrentTag, valueCurrentTag) in self.tagSelected.enumerated() {
                            if valueCurrentTag.typeTag == .hospitals && valueCurrentTag.name.lowercased() == currentTag.name.lowercased() {
                                self.tagSelected.remove(at: indexCurrentTag)
                            }
                        }
                    }
                case .doctors(_, _):
                    break
                case .prices(let currentTag, let isSelected):
                    self.tagSelected.removeAll {
                        $0.typeTag == .prices
                    }
                    
                    if isSelected {
                        self.tagSelected.append(FilterList(id: currentTag.id, name: currentTag.name, isChecked: true, isOpen: true, typeTag: .prices, subFilter: []))
                    }
                }
            }
            return bodyCell
        }
    }
}

extension FilterDoctorVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row.isMultiple(of: 2) {
            return 22 + 32
        } else {
            return UITableView.automaticDimension
        }
    }
    
}



//import UIKit
//import PanModal
//
//protocol FilterDoctorDelegate : NSObject{
//    func filterPassSelected(price : String, spesialist: String, hospital : String)
//}
//
//class FilterDoctorVC: UIViewController, PanModalPresentable {
//    var panScrollable: UIScrollView?
//
//    var showDragIndicator: Bool {
//        return false
//    }
//
//    @IBOutlet weak var resetFilterButton: UIButton!
//    @IBOutlet weak var seeAllHospitalButton: ACButton!
//    @IBOutlet weak var seeAllSpesialistButton: ACButton!
//
//    @IBOutlet weak var spesialistCollectionView: UICollectionView!
//    @IBOutlet weak var hospitalCollectionView: UICollectionView!
//    @IBOutlet weak var priceCollectionView: UICollectionView!
//
//    weak var delegate : FilterDoctorDelegate?
//
//    private lazy var filterListSpesialistView : FilterListSpesiliastVC = {
//       let vc = FilterListSpesiliastVC()
//        vc.delegate = self
//        return vc
//    }()
//
//    private lazy var filterListHospitalView : ListHospitalVC = {
//       let vc = ListHospitalVC()
//        vc.delegate = self
//        return vc
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setupButtonSeeAllHospital()
//        self.setupButtonSeeAllSpesialist()
//    }
//
//    func setupButtonSeeAllHospital() {
//        self.seeAllHospitalButton.set(type: .greenAlteaButtonText, title: "Lihat Semua")
//        self.seeAllHospitalButton.onTapped = {
//            self.presentPanModal(self.filterListHospitalView)
//        }
//    }
//
//    func setupButtonSeeAllSpesialist(){
//        self.seeAllSpesialistButton.set(type: .greenAlteaButtonText, title: "Lihat Semua")
//        self.seeAllSpesialistButton.onTapped = {
//            ///Set behavior in here
//            self.presentPanModal(self.filterListSpesialistView)
//        }
//    }
//}
//
//extension FilterDoctorVC : FilterListSpesialistDelegate {
//    func selectSpesialist(id: String, nameSpesialist: String) {
//        // ...
//    }
//}
//
//extension FilterDoctorVC : ListHospitalDelegate {
//    func selectHospital(id: String, nameHospital: String) {
//        // ..
//    }
//
//}

//                case .days(_, let currentModel, let isSelected, let index):
//                    break
//                    let onTapped = currentModel[index]
//                    if isSelected {
//                        for (indexCurrentTag, valueCurrentTag) in self.tagSelected.enumerated() {
//                            if valueCurrentTag.typeTag == .days {
//                                self.tagSelected.remove(at: indexCurrentTag)
//                            }
//                        }
//
//                        self.tagSelected.append(FilterList(id: onTapped.id, name: onTapped.name, isChecked: isSelected, typeTag: .days))
//                    }
