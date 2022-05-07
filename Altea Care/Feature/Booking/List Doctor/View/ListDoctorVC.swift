//
//  ListDoctorVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
// selanjutnya adalah cek input search, chipsbar dan hit api dikarnakan tfSearcf setup .skip 1

import UIKit
import RxSwift
import RxCocoa
import PanModal

class ListDoctorVC: UIViewController, ListDoctorView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var tfSearchSpesialist: UITextField!
    @IBOutlet weak var tblvListDoctor: UITableView!
    @IBOutlet weak var filterDayCV: UICollectionView!
    @IBOutlet weak var cvChipsBar: UICollectionView!
    @IBOutlet weak var labelSumOfData: UILabel!
    @IBOutlet weak var iconConversationView: UIImageView!
    @IBOutlet weak var containerFloatingButton: ACView!
    @IBOutlet weak var floatingLabel: UILabel!
    @IBOutlet weak var removeAllChipsbarButton: CircleButtonBackground!
    @IBOutlet weak var containerRemoveAllChipsbar: UIStackView!
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    //    private let idSpecializationRelay = BehaviorRelay<String?>(value: nil)
    //    private let isSearchRelay = BehaviorRelay<Bool?>(value: nil)
    //    private let requestRelay = BehaviorRelay<ListDoctorSpecializationBody?>(value: nil)
    private let requestSpecializationsRelay = BehaviorRelay<SpecializationsRequest?>(value: nil)
    private let requestDoctorsRelay = BehaviorRelay<DoctorsSpecializationBody?>(value: nil)
    
    
    private let disposeBag = DisposeBag()
    var viewModel: ListDoctorVM!
    var onDoctorTapped: ((String, Bool, DayName?) -> Void)?
    var backPreviousPage: (() -> Void)?
    var idSpecialist: String!
    var nameSpecialist: String!
    var isSearch: Bool!
    var inputSearch: String?
    var isBackToPreviousPage: Bool!
    var isHiddenChipsbar: Bool!
    var selectedDayName: DayName?
    var onShowFilterTapped: (([DayName], [ListSpecialistModel], [ListHospitalModel], [ListDoctorModel], [ListPrice], FilterList, [FilterList]) -> Void)?
    
    var sortSelected: String = "price:DESC"
    
    private let idDay: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "EEEE"
        let name = dateFormatter.string(from: Date())
        return name.uppercased()
    }()
    
    private let day: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let name = dateFormatter.string(from: Date())
        return name.uppercased()
    }()
    
    private var specializationsData = [ListSpecialistModel]()
    private var hospitalsData = [ListHospitalModel]()
    private var doctorsData = [ListDoctorModel]() {
        didSet {
            var countActiveDoctors: Int = 0
            for index in self.doctorsData {
                let available = index.isAvailable ?? false
                if available {
                    countActiveDoctors += 1
                }
            }
            self.setupLabel(sum: countActiveDoctors, searchKey: self.inputSearch ?? "")
            self.tblvListDoctor.reloadData() //
        }
    }
    
    private lazy var sortingView : SortPickerVC = {
        let vc = SortPickerVC()
        vc.items = [VoteModel(title: "Harga (Tertinggi - Terendah)", isSelected: self.sortSelected == "price:DESC" ? true : false, isUserSelectEnable: true),
                    VoteModel(title: "Pengalaman (Terlama - Terbaru)", isSelected: self.sortSelected == "experience:ASC" ? true : false, isUserSelectEnable: true)]
        vc.delegate = self
        return vc
    }()
    
    private var dayData = [DayName](){
        didSet{
            filterDayCV.reloadData()
        }
    }
    
    private var pricesData: [ListPrice] = [
        ListPrice(idPrice: "150000", price: "< 150 Rb", typePrice: .low), // price_lt=150000
        ListPrice(idPrice: "150000|300000", price: "150 - 300 Rb", typePrice: .mid), // price_gte=150000&price_lte=300000
        ListPrice(idPrice: "300000", price: "> 300 Rb", typePrice: .high) // price_gt=300000
    ]
    
    private var daysSelected: FilterList = FilterList(id: "", name: "", isChecked: false, isOpen: false, typeTag: .days, subFilter: []) {
        didSet {
            self.filterDayCV.reloadData()
        }
    }
    
    private var containerChipsbarModel: [TagList] = []
    private var containerChildOfChipsbarModel: [TagList] = []
    private var chipsbarDataSelected: [FilterList] = [FilterList]() {
        didSet {
            self.containerChipsbarModel.removeAll()
            for index in self.chipsbarDataSelected {
                if index.isChecked {
                    self.containerChipsbarModel.append(TagList(id: index.id, name: index.name, isChecked: index.isChecked))
                }
                
                if !index.subFilter.isEmpty {
                    for subIndex in index.subFilter {
                        if subIndex.isChecked {
                            self.containerChildOfChipsbarModel.append(TagList(id: subIndex.id, name: subIndex.name, isChecked: subIndex.isChecked))
                        }
                    }
                }
            }
            // MARK: - ADD CHILD DATA TO LAST OF SPECIALIZATION VIEW
            self.containerChipsbarModel.append(contentsOf: self.containerChildOfChipsbarModel)
            self.cvChipsBar.reloadData()
            
            self.cvChipsBar.isHidden = self.chipsbarDataSelected.isEmpty ? true : false
            self.removeAllChipsbarButton.isHidden = self.chipsbarDataSelected.count >= 1 ? false : true
            self.containerRemoveAllChipsbar.isHidden = self.chipsbarDataSelected.isEmpty ? true : false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupActions()
        self.setupDays()
        self.setupData()
        self.bindViewModel()
        self.setupNavigation()
        self.setupCell()
        self.setupDataRelay()
        self.setupView()
        self.setupLabel(sum: 0, searchKey: "")
        self.setupViewFloatingButton()
        
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
    }
    
    func onDismissFindFilter(dayTag: FilterList, dataTag: [FilterList]) {
        self.onShowFilterTapped?(
            self.dayData,
            self.specializationsData,
            self.hospitalsData,
            self.doctorsData,
            self.pricesData,
            dayTag,
            dataTag)
    }
    
    func onSubmitFindFilter(dayTag: FilterList, dataTag: [FilterList]) {
        self.onShowFilterTapped?(
            self.dayData,
            self.specializationsData,
            self.hospitalsData,
            self.doctorsData,
            self.pricesData,
            dayTag,
            dataTag)
    }
    
    func onSubmitFilter(dayTag: FilterList, dataTag: [FilterList]) {
        self.chipsbarDataSelected.removeAll()
        self.chipsbarDataSelected = dataTag
        self.daysSelected = dayTag
        self.chipsbarSelected()
    }
    
    private func setupUI() {
        self.tfSearchSpesialist.text = self.inputSearch
        self.cvChipsBar.isHidden = self.isHiddenChipsbar
        self.removeAllChipsbarButton.isHidden = self.isHiddenChipsbar
        self.containerRemoveAllChipsbar.isHidden = self.isHiddenChipsbar
        self.removeAllChipsbarButton.setupButton(style: .clear(title: "Hapus", color: "61C7B5"), sizeFont: 14, fontType: .weight500)
    }
    
    private func setupActions() {
        self.removeAllChipsbarButton.addTapGestureRecognizer {
            self.chipsbarDataSelected.removeAll()
            self.chipsbarSelected()
        }
    }
    
    private func setupData() {
        if !self.idSpecialist.isEmpty {
            self.chipsbarDataSelected.append(FilterList(
                id: self.idSpecialist,
                name: self.nameSpecialist,
                isChecked: true,
                isOpen: true,
                typeTag: .specializations,
                subFilter: []))
        }
    }
    
    private func setupDataRelay() {
        self.viewDidLoadRelay.accept(())
        //        self.idSpecializationRelay.accept(idSpecialist)
        //        self.requestRelay.accept(ListDoctorSpecializationBody(id: idSpecialist, available_day: idDay, query: inputSearch))
        //        self.isSearchRelay.accept(isSearch)
        
        self.requestSpecializationsRelay.accept(SpecializationsRequest(
            id: nil,
            _q: nil,
            _limit: nil,
            _page: nil,
            is_popular: nil))
        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
            id: self.chipsbarDataSelected.isEmpty ? nil : [self.idSpecialist],
            available_day: self.idDay,
            query: self.getInputSearch(),
            limit: "500",
            page: nil,
            idHospital: nil,
            priceLt: nil,
            priceGt: nil,
            priceLte: nil,
            priceGte: nil,
            sort: "price:DESC",
            isPopular: nil))
    }
    
    private func setupViewFloatingButton() {
        //        self.containerFloatingButton.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.containerFloatingButton.shadowImage = UIImage()
        self.containerFloatingButton.layer.masksToBounds = false
        self.containerFloatingButton.layer.shadowColor = UIColor.lightGray.cgColor
        self.containerFloatingButton.layer.shadowOpacity = 0.8
        self.containerFloatingButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.containerFloatingButton.layer.shadowRadius = 4
    }
    
    private func setupDays(){
        var dates = [DayName]()
        for indexDate in 0...6 {
            let idDay = Date().getIdDayByAdding(count: indexDate, date: Date())
            let day = Date().getDayByAdding(count: indexDate, date: Date())
            let date = Date().getDateByAdding(count: indexDate, date: Date())
            dates.append(DayName(id: idDay, day: day, date: date))
        }
        self.dayData = dates
        self.selectedDayName = dayData[0]
        self.daysSelected = FilterList(id: self.dayData[0].id, name: self.dayData[0].day, isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLabel(sum: Int, searchKey: String){
        if sum > 0 {
            self.labelSumOfData.isHidden = false
            self.labelSumOfData.text = "Menampilkan \(sum) data"
        }else{
            self.labelSumOfData.isHidden = true
        }
        self.labelSumOfData.textColor = UIColor.alteaBlueMain
//
//        let sumOfDoctorString = "Menampilkan 1-\(sum) Spesialis untuk \(searchKey)"
//        let boldText = NSMutableAttributedString(string: sumOfDoctorString)
//        let rangeBold = (sumOfDoctorString as NSString).range(of: searchKey)
//        boldText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: rangeBold)
    }
    
    func bindViewModel() {
        let input = ListDoctorVM.Input(
            viewDidLoadRelay: viewDidLoadRelay.asObservable(),
            //            idSpecialization: self.idSpecializationRelay.asObservable(),
            //            isSearch: self.isSearchRelay.asObservable(),
            //            request: requestRelay.asObservable(),
            modelSpecializations: self.requestSpecializationsRelay.asObservable(),
            modelDoctors: self.requestDoctorsRelay.asObservable())
        
        let output = viewModel.transform(input)
        disposeBag.insert([
            output.state.drive(self.rx.state),
            output.state.drive { (_) in
                //self.refreshControl.endRefreshing()
            },
            output.specializations.drive { (list) in
                self.specializationsData = list
            },
            output.hospitals.drive { (list) in
                self.hospitalsData = list
            },
            output.doctors.drive { (list) in
                self.doctorsData = list
            },
        ])
    }
    
    private func setupView() {
        self.disposeBag.insert([
            backButton.rx.tap
                .do(onNext: {
                }).subscribe(onNext: {[unowned self] in
                    if (isBackToPreviousPage){
                        backPreviousPage?()
                    }else {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }, onError: { _ in
                }),
            
            rangeButton.rx.tap
                .do(onNext: {
                }).subscribe(onNext: { [unowned self] in
                    presentPanModal(sortingView)
                }, onError: { _ in
                }),
            
            filterButton.rx.tap
                .do(onNext: {
                }).subscribe(onNext: { [unowned self] in
                    
                    self.onShowFilterTapped?(
                        self.dayData,
                        self.specializationsData,
                        self.hospitalsData,
                        self.doctorsData,
                        self.pricesData,
                        self.daysSelected,
                        self.chipsbarDataSelected)
                }, onError: { _ in
                })
        ])
        
        self.tfSearchSpesialist.rx.text.orEmpty
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                if text != self.inputSearch {
                    self.inputSearch = text
                    self.chipsbarSelected()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupCell() {
        self.tblvListDoctor.delegate = self
        self.tblvListDoctor.dataSource = self
        self.filterDayCV.delegate = self
        self.filterDayCV.dataSource = self
        self.cvChipsBar.delegate = self
        self.cvChipsBar.dataSource = self
        
        let nibListDoctor = UINib(nibName: "ListDoctorTableViewCell", bundle: nil)
        self.tblvListDoctor.register(nibListDoctor, forCellReuseIdentifier: "ListDoctorTableViewCell")
        self.tblvListDoctor.registerNIB(with: EmptyDoctorScheduleCell.self)
        
        let flowDayLayout = UICollectionViewFlowLayout()
        flowDayLayout.minimumLineSpacing = 6.0
        flowDayLayout.itemSize = CGSize(width: 70, height: 30)
        flowDayLayout.scrollDirection = .horizontal
        
        self.filterDayCV.collectionViewLayout = flowDayLayout
        let cellNib = UINib(nibName: "DayCollectionViewCell", bundle: nil)
        self.filterDayCV.register(cellNib, forCellWithReuseIdentifier: "dayNameCell")
        let indexPath = self.filterDayCV.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
        self.filterDayCV.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        
        let cellNibChips = UINib(nibName: "ChipsBarCell", bundle: nil)
        self.cvChipsBar.register(cellNibChips, forCellWithReuseIdentifier: "ChipsBarCell")
        if !self.chipsbarDataSelected.isEmpty {
            let indexPathChips = self.cvChipsBar.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
            self.cvChipsBar.selectItem(at: indexPathChips, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            
        }
    }
    
    private func setupCell(data: ListDoctorModel, cell: ListDoctorTableViewCell) {
        if data.imagePerson!.isEmpty || data.imagePerson! == "-" {
            cell.personIV.image = UIImage(named: "IconAltea")
        } else{
            if let urlPhotoPerson = URL(string: data.imagePerson ?? "-") {
                cell.personIV.kf.setImage(with: urlPhotoPerson)
            }
        }
        
        if let urlPhotoHospital = URL(string: data.imageHospital ?? "-") {
            cell.hospitalIV.kf.setImage(with: urlPhotoHospital)
        }
        cell.doctorLabel.text = data.name
        cell.experienceLabel.text = data.experience
        
        cell.langLabel.text = "Indonesia"
        cell.specializeLabel.text = data.specialization
        cell.hospitalNameLabel.text = data.nameHospital
        cell.onlineView.backgroundColor = data.isAvailable == true ? .alteaGreenMain : .alteaDark3
        cell.praktikLabel.text = data.isAvailable == true ? "Praktik" : "Tidak Praktik"
        cell.freeIV.isHidden = !data.isFree
        if data.isFree{
            cell.flatPriceLabel.isHidden = true
            cell.priceLabel.text = data.formattedPrice
        }else{
            if data.promoPriceRaw == 0{
                cell.flatPriceLabel.isHidden = true
                cell.priceLabel.text = data.formattedPrice
            }else{
                cell.flatPriceLabel.isHidden = false
                cell.priceLabel.text = data.promoPriceFormatted
                let attrString = NSAttributedString(string: data.formattedPrice, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                cell.flatPriceLabel.attributedText = attrString
                cell.flatPriceLabel.text = data.formattedPrice
            }
        }
    }
    
    private func chipsbarSelected() {
        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
            id: self.getIdData(typeTag: .specializations),
            available_day: self.daysSelected.id.isEmpty ? nil : self.daysSelected.id,
            query: self.getInputSearch(),
            limit: "500",
            page: nil,
            idHospital: self.getIdData(typeTag: .hospitals),
            priceLt: self.getIdPrice(type: .priceLt),
            priceGt: self.getIdPrice(type: .priceGt),
            priceLte: self.getIdPrice(type: .priceLte),
            priceGte: self.getIdPrice(type: .priceGte),
            sort: self.sortSelected,
            isPopular: nil))
    }
        
    private func getIdPrice(type: TypePriceDoctor) -> String? {
        let idPrice: String = self.getIdData(typeTag: .prices)?[0] ?? ""
        if idPrice.isEmpty {
            return nil
        } else {
            switch type {
            case .priceLt:
                return idPrice == "150000" ? idPrice : nil
            case .priceGt:
                return idPrice == "300000" ? idPrice : nil
            case .priceLte:
                return idPrice == "150000|300000" ? "300000" : nil
            case .priceGte:
                return idPrice == "150000|300000" ? "150000" : nil
            }
        }
    }
    
    private func getIdData(typeTag: TypeTagCollection) -> [String]? {
        var id: [String] = [String]()
        
        switch typeTag {
        case .specializations:
            for (_, value) in self.chipsbarDataSelected.enumerated() {
                if value.typeTag == .specializations {
                    if value.isChecked {
                        id.append(value.id)
                    }
                    
                    if !value.subFilter.isEmpty {
                        for subValue in value.subFilter {
                            if subValue.isChecked {
                                id.append(subValue.id)
                            }
                        }
                    }
                }
            }
            
            return id == [] ? nil : id
        case .hospitals:
            for (_, value) in self.chipsbarDataSelected.enumerated() {
                if value.typeTag == .hospitals {
                    id.append(value.id)
                }
            }
            
            return id == [] ? nil : id
        case .doctors:
            for (_, value) in self.chipsbarDataSelected.enumerated() {
                if value.typeTag == .doctors {
                    id.append(value.id)
                }
            }
            
            return id == [] ? nil : id
        case .prices:
            for (_, value) in self.chipsbarDataSelected.enumerated() {
                if value.typeTag == .prices {
                    id.append(value.id)
                }
            }
            
            return id == [] ? nil : id
        default:
            break
        }
        
        
        return nil
    }
    
    private func removeChipsbarById(id: String) {
        for (index, value) in self.chipsbarDataSelected.enumerated() {
            
            if id.lowercased() == value.id.lowercased() {
                self.chipsbarDataSelected.remove(at: index)
            }
        }
    }
    
    private func getInputSearch()  -> String? {
        let search = self.inputSearch ?? ""
        return search.isEmpty ? nil : search
    }
}

extension ListDoctorVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.doctorsData.count == 0 {
            return 1
        } else {
            return self.doctorsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.doctorsData.isEmpty {
            guard let cell = tableView.dequeueCell(with: EmptyDoctorScheduleCell.self) else {
                return UITableViewCell()
            }
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ListDoctorTableViewCell") as! ListDoctorTableViewCell
            let target = self.doctorsData[indexPath.row]
            setupCell(data: target, cell: cell)
            cell.actionGoToDetailDoctor = {
                self.onDoctorTapped?(self.doctorsData[indexPath.row].doctorId ?? "", true, self.selectedDayName)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !self.doctorsData.isEmpty {
            self.onDoctorTapped?(self.doctorsData[indexPath.row].doctorId ?? "", true, selectedDayName)
        }
    }
}

extension ListDoctorVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvChipsBar {
            let label = UILabel(frame: CGRect.zero)
            label.font = .font(size: 9, fontType: .normal)
            label.text = self.containerChipsbarModel[indexPath.item].name // disini crash kalau ada child yang dipilih
            label.sizeToFit()
            let buttonWidth = 20.0
            let constraint = 16.0 + 4.0 + 5.0
            let cellWidth = label.frame.width + buttonWidth + constraint
            return CGSize(width: cellWidth, height: 30)
        }
        
        return CGSize(width: 70, height: 30)
        
    }
}

extension ListDoctorVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterDayCV {
            return self.dayData.count
        }
        if collectionView == self.cvChipsBar {
            return self.containerChipsbarModel.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.filterDayCV {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayNameCell", for: indexPath) as? DayCollectionViewCell else {return UICollectionViewCell()}
            let model =  self.dayData[indexPath.row]
            
            cell.setupDay(day: indexPath.row == 0 ? "Hari ini" : model.day)
            
            if model.id.lowercased() == self.daysSelected.id.lowercased() {
                cell.setupBackgroundColorSelected()
            } else {
                cell.setupBackgroundColorDeselected()
            }
            
            return cell
        }
        
        if collectionView == self.cvChipsBar {
            // disini
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsBarCell", for: indexPath) as? ChipsBarCell else {return UICollectionViewCell()}
            
            cell.setupTitleChipsbar(model: self.containerChipsbarModel[indexPath.row])
            
            cell.onRemoveChipsbarTapped = { [weak self] (modelFilter) in
                guard let self = self else { return }
                self.removeChipsbarById(id: modelFilter.id)
                self.chipsbarSelected()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.filterDayCV {
            self.selectedDayName = self.dayData[indexPath.row]
            self.setupDaySelected()
            self.chipsbarSelected()
            self.setupTracker(day: self.dayData[indexPath.row].day)
        }
    }
    
    func setupDaySelected() {
        if selectedDayName?.day.lowercased() == "senin"{
            self.daysSelected = FilterList(id: "MONDAY", name: "Senin", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "selasa"{
            self.daysSelected = FilterList(id: "TUESDAY", name: "Selasa", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "rabu"{
            self.daysSelected = FilterList(id: "WEDNESDAY", name: "Rabu", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "kamis"{
            self.daysSelected = FilterList(id: "THURSDAY", name: "Kamis", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "jumat"{
            self.daysSelected = FilterList(id: "FRIDAY", name: "Jumat", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "sabtu"{
            self.daysSelected = FilterList(id: "SATURDAY", name: "Sabtu", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }else if selectedDayName?.day.lowercased() == "minggu"{
            self.daysSelected = FilterList(id: "SUNDAY", name: "Minggu", isChecked: true, isOpen: true, typeTag: .days, subFilter: [])
        }
    }
}

extension ListDoctorVC : SortPickerDelegate {
    
    func priceHighLow() {
        self.sortSelected = "price:DESC"
        self.chipsbarSelected()
    }
    
    func priceLowHigh() {
        self.sortSelected = "price:ASC"
        self.chipsbarSelected()
    }
    
    func experienceOldestNewest() {
        self.sortSelected = "experience:DESC"
        self.chipsbarSelected()
    }
    
    func experienceNewestOldest() {
        self.sortSelected = "experience:ASC"
        self.chipsbarSelected()
    }
    
    func popularitySelected() {
        
    }
    
    
    func didSelect(_ picker: SortPickerVC, index: Int) {
        switch index {
        case 0:
            self.priceSelected()
            break
        case 1:
            self.experienceSelected()
            break
        default:
            break
        }
    }
    
    func priceSelected() {
        //        model = model.sorted {
        //            $0.promoPriceRaw ?? 0 > $1.promoPriceRaw ?? 0
        //        }
    }
    
    func experienceSelected() {
        //        model = model.sorted {
        //            $0.experience ?? "" > $1.experience ?? ""
        //        }
    }
}

enum DayType : String {
    case today = ""
    case senin = "MONDAY"
    case selasa = "TUESDAY"
    case rabu = "WEDNESDAY"
    case kamis = "THURSDAY"
    case jumat = "FRIDAY"
    case sabtu = "SATURDAY"
    case minggu = "SUNDAY"
}

//MARK: - Setup Tracker
extension ListDoctorVC {
    
    func setupTracker(day: String) {
        self.track(.filterDayInCategory(AnalyticsFilterDayCategory(choosingDay: day)))
    }
}

enum TypePriceDoctor {
    case priceLt
    case priceGt
    case priceLte
    case priceGte
}


//print("hailny adalh \(isDaysSelected) \\ \(isSpecializationsSelected) \\ \(isHospitalsSelected) \\ \(isPricesSelected) \\ ")
//
//if isDaysSelected && isSpecializationsSelected && isHospitalsSelected && isPricesSelected {
//    // HIT API : hari, spesialis, hospitals, prices
//    self.apiSeviceAllTag()
//} else if isDaysSelected && isSpecializationsSelected && isHospitalsSelected && !isPricesSelected {
//    // HIT API : hari, spesialis, hospitals
//    self.apiSeviceDaySpecialistHospital()
//} else if isDaysSelected && !isSpecializationsSelected && isHospitalsSelected && isPricesSelected {
//    // HIT API : hari, hospitals, prices
//    self.apiSeviceDayHospitalPrice()
//} else if !isDaysSelected && isSpecializationsSelected && isHospitalsSelected && isPricesSelected {
//    // HIT API : spesialis, hospitals, prices
//    self.apiSeviceSpecialistHospitalPrice()
//} else if isDaysSelected && isSpecializationsSelected && !isHospitalsSelected && !isPricesSelected {
//    // HIT API : hari, dan spesialis
//    self.apiSeviceDaySpecialist()
//} else if isDaysSelected && !isSpecializationsSelected && isHospitalsSelected && !isPricesSelected {
//    // HIT API : hari, dan hospitals
//    self.apiSeviceDayHospital()
//} else if isDaysSelected && !isSpecializationsSelected && !isHospitalsSelected && isPricesSelected {
//    // HIT API : hari, dan prices
//    self.apiSeviceDayPrice()
//} else if !isDaysSelected && isSpecializationsSelected && isHospitalsSelected && !isPricesSelected {
//    // HIT API : spesialis, hospitals
//    self.apiSeviceSpecialistHospital()
//} else if !isDaysSelected && isSpecializationsSelected && !isHospitalsSelected && isPricesSelected {
//    // HIT API : spesialis, prices
//    self.apiSeviceSpecialistPrice()
//} else if !isDaysSelected && !isSpecializationsSelected && isHospitalsSelected && isPricesSelected {
//    // HIT API : hospital, prices
//    self.apiSeviceHospitalPrice()
//} else if isDaysSelected && !isSpecializationsSelected && !isHospitalsSelected && !isPricesSelected {
//    // HIT API : hari
//    self.apiSeviceDay()
//} else if !isDaysSelected && isSpecializationsSelected && !isHospitalsSelected && !isPricesSelected {
//    // HIT API : spesialis
//    self.apiSeviceSpecialist()
//} else if !isDaysSelected && !isSpecializationsSelected && isHospitalsSelected && !isPricesSelected {
//    // HIT API : hospital
//    self.apiSeviceHospital()
//} else if !isDaysSelected && !isSpecializationsSelected && !isHospitalsSelected && isPricesSelected {
//    // HIT API : price
//    self.apiSevicePrice()
//} else if !isDaysSelected && !isSpecializationsSelected && !isHospitalsSelected && !isPricesSelected {
//    // HIT API : RESET
//    self.apiSeviceReset()
//} else {
//    print("RESPONSE FROM : Nothing api hit \(isDaysSelected) \\ \(isSpecializationsSelected) \\ \(isHospitalsSelected) \\ \(isPricesSelected) \\ ")
//}
//private func apiSeviceSearch() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: [self.idSpecialist],
//        available_day: self.daysSelected.id,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: nil,
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceReset() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: nil,
//        available_day: nil,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: nil,
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSevicePrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceHospital() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: nil,
//        available_day: nil,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: self.getIdData(typeTag: .hospitals),
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceSpecialist() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: self.getIdData(typeTag: .specializations),
//        available_day: nil,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: nil,
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceDay() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: nil,
//        available_day: self.daysSelected.id,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: nil,
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceHospitalPrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceSpecialistPrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceSpecialistHospital() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: [self.idSpecialist],
//        available_day: nil,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: self.getIdData(typeTag: .hospitals),
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceDayPrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: nil,
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceDayHospital() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: nil,
//        available_day: self.daysSelected.id,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: self.getIdData(typeTag: .hospitals),
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceDaySpecialist() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: self.getIdData(typeTag: .specializations),
//        available_day: self.daysSelected.id,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: nil,
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceSpecialistHospitalPrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: nil,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceDayHospitalPrice() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: nil,
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
//
//private func apiSeviceDaySpecialistHospital() {
//    self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//        id: self.getIdData(typeTag: .specializations),
//        available_day: self.daysSelected.id,
//        query: self.getInputSearch(),
//        limit: "500",
//        page: nil,
//        idHospital: self.getIdData(typeTag: .hospitals),
//        priceLt: nil,
//        priceGt: nil,
//        priceLte: nil,
//        priceGte: nil,
//        sort: self.sortSelected,
//        isPopular: nil))
//}
//
//private func apiSeviceAllTag() {
//    if self.getIdData(typeTag: .prices)?[0] == "150000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: "150000",
//            priceGt: nil,
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "150000|300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: nil,
//            priceLte: "300000",
//            priceGte: "150000",
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//
//    if self.getIdData(typeTag: .prices)?[0] == "300000" {
//        self.requestDoctorsRelay.accept(DoctorsSpecializationBody(
//            id: self.getIdData(typeTag: .specializations),
//            available_day: self.daysSelected.id,
//            query: self.getInputSearch(),
//            limit: "500",
//            page: nil,
//            idHospital: self.getIdData(typeTag: .hospitals),
//            priceLt: nil,
//            priceGt: "300000",
//            priceLte: nil,
//            priceGte: nil,
//            sort: self.sortSelected,
//            isPopular: nil))
//    }
//}
