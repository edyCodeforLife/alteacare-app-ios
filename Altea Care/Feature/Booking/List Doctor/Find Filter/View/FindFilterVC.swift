//
//  FindFilterVC.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 29/12/21.
//

import UIKit


struct TagList {
    let id: String
    let name: String
    let isChecked: Bool
}

struct FilterList {
    let id: String
    let name: String
    var isChecked: Bool
    var isOpen: Bool
    let typeTag: TypeTagCollection
    var subFilter: [FilterList]
    
    mutating func checkIsFilterSelected(filterSelected: [FilterList]) {
        for filter in filterSelected {
            if id == filter.id {
                isChecked = true
            }
        }
    }
}




class FindFilterVC: UIViewController, FindFilterView {
    
    var typeSelected: TypeTagCollection!
    var tagSelected: [FilterList]! // -> langsung ubah value menggunakan ini, tidak menggunakan penampung value coba pakai print
    var daySelected: FilterList!
    var specializations: [ListSpecialistModel]!
    var hospitals: [ListHospitalModel]!
    var doctors: [ListDoctorModel]!
    var onCloseView: (() -> Void)?
    var onFindFilterTapped: ((FilterList, [FilterList]) -> Void)?
    
    private var baseModel: [FilterList] = [FilterList]() // Base Data from Response
    private var resultFilters: [FilterList] = [FilterList]() // result filter model / base on input filter or typing textfield
    
    
    @IBOutlet weak var closeView: UIImageView!
    @IBOutlet weak var titleHeader: ACLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: CircleButtonBackground!
    @IBOutlet weak var searchView: SearchToolbarAtom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.bindViewModel()
        self.setupUI()
        self.setupActions()
        
//        print("note irfan : FindFilterVC viewDidLoad \(self.tagSelected)")
//        print("")
//        print("")
//        print("note irfan : FindFilterVC viewDidLoad \(self.baseModel)")
//        print("")
//        print("")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // self.onCloseView?()
    }
    
    func bindViewModel() {
    }
    
    private func setupData() {
        switch self.typeSelected {
        case .specializations:
            for name in self.specializations {
                self.baseModel.append(
                    FilterList(
                        id: name.specializationId ?? "",
                        name: name.name ?? "",
                        isChecked: self.setupChecklistData(id: name.specializationId ?? ""),
                        isOpen: self.setupChecklistData(id: name.specializationId ?? ""),
                        typeTag: .specializations,
                        subFilter: self.checkSubSpecialization(name)))
            }
        case .hospitals:
            for name in self.hospitals {
                self.baseModel.append(
                    FilterList(
                        id: name.hospitalId ,
                        name: name.name,
                        isChecked: self.setupChecklistData(id: name.hospitalId),
                        isOpen: false,
                        typeTag: .hospitals,
                        subFilter: []
                    ))
            }
        default:
            break
        }
        
        self.resultFilters = self.baseModel
    }
    
    private func setupUI() {
        self.titleHeader.font = .font(size: 14, fontType: .bold)
        switch self.typeSelected {
        case .days:
            self.titleHeader.text = ""
        case .specializations:
            self.titleHeader.text = "Dokter Spesialis"
        case .hospitals:
            self.titleHeader.text = "Rumah Sakit"
        case .doctors:
            self.titleHeader.text = "Dokter"
        case .prices:
            self.titleHeader.text = ""
        case .empty:
            break
        case .none:
            break
        }
        self.submitButton.setupButton(style: .fill(title: "Terapkan", color: "FFFFFF", background: "61C7B5", radius: 6), sizeFont: 16, fontType: .weight700)
        self.closeView.isHidden = false
        self.setupTableView()
    }
    
    private func setupActions() {
        self.searchView.inputSearch.addTarget(self, action: #selector(FindFilterVC.textFieldDidChange(_:)), for: .editingChanged)
        self.closeView.addTapGestureRecognizer {
            self.onCloseView?()
        }
        self.submitButton.addTapGestureRecognizer {
            // MARK: - REMOVE DATA TAG FROM MODEL BY TYPE DATA
            switch self.typeSelected {
            case .specializations:
                self.tagSelected.removeAll { value in
                    value.typeTag == .specializations
                }
            case .hospitals:
                self.tagSelected.removeAll { value in
                    value.typeTag == .hospitals
                }
            default:
                break
            }
            
            // MARK: - INSERT DATA FROM SELECTED USER
            for (_, value) in self.baseModel.enumerated() {
                // MARK: - HOSPITALS
                if value.typeTag == .hospitals && value.isChecked == true {
                    self.tagSelected.append(value)
                }
                // MARK: - SPESIALIS
                if value.typeTag == .specializations {
                    if value.subFilter.isEmpty {
                        if value.isChecked {
                            self.tagSelected.append(value)
                        }
                    } else {
                        // MARK: - FIRST INSERT DATA EVEN TRUE OR FALSE
                        if value.isChecked {
                            self.tagSelected.append(value)
                        } else {
                            
                            var isParentChecked: [Bool] = []
                            for (_, subValue) in value.subFilter.enumerated() {
                                isParentChecked.append(subValue.isChecked)
                            }
                            if isParentChecked.contains(where: { $0 == true }) {
                                self.tagSelected.append(value)
                            }
                        }
                    }
                }
            }
//            print("note irfan : FindFilterVC submitButton \(self.daySelected)")
//            print("")
//            print("")
//            print("note irfan : FindFilterVC submitButton \(self.tagSelected)")
//            print("")
//            print("")
                        
            self.onFindFilterTapped?(self.daySelected, self.tagSelected)
        }
        
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SelectFindFilterCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SelectFindFilterCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let input = textField.text ?? ""
        if input.isEmpty {
            self.resultFilters = self.baseModel
        } else {
            self.resultFilters = self.resultFilters.filter{
                $0.name.lowercased().contains(input.lowercased())
            }
        }
        self.tableView.reloadData()
        
    }
    
    private func checkSubSpecialization(_ model: ListSpecialistModel) -> [FilterList] {
        
        func isSubSpecializationChecklist(id: String) -> Bool {
            switch self.typeSelected {
            case .specializations:
                for valueTag in self.tagSelected {
                    if !valueTag.subFilter.isEmpty {
                        for subValue in valueTag.subFilter {
                            if subValue.isChecked == true && subValue.id.lowercased() == id.lowercased() {
                                return true
                            }
                        }
                    }
                }
            default:
                return false
            }
            return false
        }
        
        
        var subFilter: [FilterList] = []
        let subSpecialization = model.subSpecialization ?? []
        
        if subSpecialization.isEmpty {
            return subFilter
        } else {
            for index in subSpecialization {
                subFilter.append(
                    FilterList(
                        id: index.specializationId ?? "",
                        name: index.name ?? "",
                        isChecked: isSubSpecializationChecklist(id : index.specializationId ?? ""),
                        isOpen: isSubSpecializationChecklist(id : index.specializationId ?? ""),
                        typeTag: .specializations,
                        subFilter: []))
            }
            
            return subFilter
        }
    }
    
    private func setupChecklistSubData(id: String) -> Bool {
        switch self.typeSelected {
        case .specializations:
            for valueTag in self.tagSelected {
                if !valueTag.subFilter.isEmpty {
                    for subValue in valueTag.subFilter {
                        if subValue.isChecked {
                            if  valueTag.typeTag == .specializations && valueTag.isChecked == true && valueTag.id.lowercased() == id.lowercased() {
                                return true
                            }
                        }
                    }
                }
            }
        default:
            return false
        }
        return false
    }
    
    private func setupChecklistData(id: String) -> Bool {
        switch self.typeSelected {
        case .specializations:
            for valueTag in self.tagSelected {
                if  valueTag.typeTag == .specializations && valueTag.isChecked == true && valueTag.id.lowercased() == id.lowercased() {
                    return true
                }
            }
        case .hospitals:
            for valueTag in self.tagSelected {
                if  valueTag.typeTag == .hospitals && valueTag.isChecked == true && valueTag.id.lowercased() == id.lowercased() {
                    return true
                }
            }
        default:
            return false
        }
        return false
    }
    
}

extension FindFilterVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultFilters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultFilters[section].isOpen {
            return resultFilters[section].subFilter.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = resultFilters[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFindFilterCell", for: indexPath) as! SelectFindFilterCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.filterData = cellData
        } else {
            cell.filterData = cellData.subFilter[indexPath.row - 1]
            cell.setToChildCell()
        }
        
        cell.onExpandTapped = { [weak self] isOpen in
            if(indexPath.row == 0){
                self?.resultFilters[indexPath.section].isOpen = isOpen
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .automatic)
            }
        }
        
        cell.onChecklistTapped = { [weak self] isChecked in
            guard let self = self else { return }
            
            if(indexPath.row == 0) {
                // MARK: - FOR BASE MODEL
                for (index, value)in self.baseModel.enumerated() {
                    if value.typeTag == .hospitals && value.id.lowercased() == self.resultFilters[indexPath.section].id.lowercased() {
                        self.baseModel[index].isChecked = isChecked
                    }
                    
                    if value.typeTag == .specializations && value.id.lowercased() == self.resultFilters[indexPath.section].id.lowercased() {
                        self.baseModel[index].isChecked = isChecked
                        self.baseModel[index].isOpen = isChecked
                        
                        if !self.baseModel[index].subFilter.isEmpty {
                            for (subIndex, _) in value.subFilter.enumerated() {
                                self.baseModel[index].subFilter[subIndex].isChecked = isChecked
                                self.baseModel[index].subFilter[subIndex].isOpen = isChecked
                            }
                            
//                            print("note : baseModel \(self.baseModel[index])")
                        }
                    }
                    
                    
                }
                
                // MARK: - FOR RESULT FILTERS
                self.resultFilters[indexPath.section].isChecked = isChecked
                self.resultFilters[indexPath.section].subFilter = cellData.subFilter.map {
                    var tempFilter = $0
                    tempFilter.isChecked = isChecked
                    return tempFilter
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
                
//                print("note : irfan atas")
//                print("note : resultFilters \(self.resultFilters[indexPath.section])")
            } else {
                var isParentChecked: [Bool] = []
                self.resultFilters[indexPath.section].subFilter[indexPath.row - 1].isChecked = isChecked
                
                // MARK: - UNCHECK PARENT IF CHILD UNCHECKLIST FOR SOME DATA
                for (_, subValue) in self.resultFilters[indexPath.section].subFilter.enumerated() {
                    isParentChecked.append(subValue.isChecked)
                }
                if isParentChecked.allSatisfy({$0}) {
                    self.resultFilters[indexPath.section].isChecked = true
                } else {
                    self.resultFilters[indexPath.section].isChecked = false
                }
                
                // MARK: - SETUP DATA FOR BASE MODEL
                for (index, value) in self.baseModel.enumerated() {
                    if value.typeTag == .specializations {
                        // MARK: - CHECK UNCHECK PARAENT DATA BASE MODEL
                        if self.resultFilters[indexPath.section].id.lowercased() == value.id.lowercased() {
                            self.baseModel[index].isChecked = self.resultFilters[indexPath.section].isChecked
                        }
                        // MARK: - CHECK UNCHECK CHILD DATA BASE MODEL
                        for (subIndex, subValue) in value.subFilter.enumerated() {
                            if subValue.id == self.resultFilters[indexPath.section].subFilter[indexPath.row - 1].id {
                                
                                self.baseModel[index].subFilter[subIndex].isChecked = self.resultFilters[indexPath.section].subFilter[indexPath.row - 1].isChecked
                            }
                        }
                    }
                }
                
                
                
//                let indexPath = IndexPath(item: indexPath.row, section: indexPath.section)
//                tableView.reloadRows(at: [indexPath], with: .none)
                
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
                
//                print("note : irfan bawah")
//                 print("note : resultFilters \(self.resultFilters[indexPath.section])")
            }
        }
        return cell
    }
    
    
}

extension FindFilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//    private func getFilter(names: [String]) -> FilterList {
//
//        for (_, model) in self.baseModel.enumerated() {
//            if names[0] == model.name {
//                return model
//            }
//        }
//        return FilterList(id: "", name: "", isChecked: false, isOpen: false, typeTag: .empty, subFilter: [])
//    }
    
    // IRFAN : periksa lagi / harusnya udah bener
//    private func isChecklist(names: [String]) -> Bool {
//        for (_, model) in self.resultSelected.enumerated() {
//            if names[0] == model.name {
//                return true
//            }
//        }
//        return false
//    }
