//
//  TagCollectionFilterCell.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 28/12/21.
//

import UIKit
import TTGTags

enum TypeTagCollection {
    case empty
    case days
    case specializations
    case hospitals
    case doctors
    case prices
}

enum TypeTagPrice {
    case low
    case mid
    case high
}

struct ListPrice {
    let idPrice: String
    let price: String
    let typePrice: TypeTagPrice
}

struct SendTagCollectionModel {
    let send: SendTagCollection
}

enum SendTagCollection {
    case days(currentTag: TagList, isSelected: Bool)
    case specializations(currentTag: TagList, isSelected: Bool)
    case hospitals(currentTag: TagList, isSelected: Bool)
    case doctors(currentTag: TagList, isSelected: Bool)
    case prices(currentTag: TagList, isSelected: Bool)
}

class TagCollectionFilterCell: UITableViewCell, TTGTextTagCollectionViewDelegate {
    
    
    var onTagSelected: ((SendTagCollectionModel) -> Void)?
    
    @IBOutlet weak var tagCollection: TTGTextTagCollectionView!
    
    var content = TTGTextTagStringContent.init(text: "")
    var configStyle = TTGTextTagStyle.init()
    var selectedStyle = TTGTextTagStyle.init()
    
//    private var currentDaySelected: TagList = TagList(id: "", name: "", isChecked: false)
//    private var currentSpecializationsSelected: [TagList] = [TagList]()
//    private var currentHospitalsSelected: [TagList] = [TagList]()
//    private var currentPricesSelected: [TagList] = [TagList]()
    
    private var currentTypeTagSelected: TypeTagCollection = .days
    private var currentDaysModel: [TagList] = [TagList]()
    private var currentPricesModel: [TagList] = [TagList]()
    private var currentSpecializationsModel: [TagList] = [TagList]()
    private var currentHospitalsModel: [TagList] = [TagList]()
    
    private var currentChildOfSpecializationsModel: [TagList] = [TagList]()
            
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
      
        self.tagCollection.updateTag(at: index, selected: tag.selected)
        
        switch self.currentTypeTagSelected {
        case .empty:
            break
        case .days:
            // MARK: - REMARK CELL COLOR
            let onTapped = self.currentDaysModel[Int(index)]
            for (indexMarkCell, currentMarkCell) in self.currentDaysModel.enumerated() {
                if currentMarkCell.name == onTapped.name {
                    self.tagCollection.updateTag(at: UInt(indexMarkCell), selected: tag.selected)
                } else {
                    self.tagCollection.updateTag(at: UInt(indexMarkCell), selected: false)
                }
            }
            self.onTagSelected?(SendTagCollectionModel(send: .days(currentTag: onTapped, isSelected: tag.selected)))
        case .specializations:
            let onTapped = self.currentSpecializationsModel[Int(index)]
            self.onTagSelected?(SendTagCollectionModel(send: .specializations(currentTag: onTapped, isSelected: tag.selected)))
        case .hospitals:
            let onTapped = self.currentHospitalsModel[Int(index)]
            self.onTagSelected?(SendTagCollectionModel(send: .hospitals(currentTag: onTapped, isSelected: tag.selected)))
        case .doctors:
            break
        case .prices:
            // MARK: - REMARK CELL COLOR
            let onTapped = self.currentPricesModel[Int(index)]
            for (indexMarkCell, currentMarkCell) in self.currentPricesModel.enumerated() {
                if currentMarkCell.name == onTapped.name {
                    self.tagCollection.updateTag(at: UInt(indexMarkCell), selected: tag.selected)
                } else {
                    self.tagCollection.updateTag(at: UInt(indexMarkCell), selected: false)
                }
            }
            
            self.onTagSelected?(SendTagCollectionModel(send: .prices(currentTag: onTapped, isSelected: tag.selected)))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tagCollection.alignment = .left
        self.tagCollection.numberOfLines = 5
        self.tagCollection.horizontalSpacing = 8
        self.tagCollection.verticalSpacing = 8
        
        self.content.textColor = UIColor(hexString: "3E8CB9")
        self.content.textFont = UIFont.font(size: 14, fontType: .normal)
        
        self.configStyle.backgroundColor = .white
        self.configStyle.borderColor = UIColor(hexString: "3E8CB9")
        self.configStyle.borderWidth = 1
        self.configStyle.cornerRadius = 20
        self.configStyle.extraSpace = CGSize.init(width: 24, height: 20)
        
        self.selectedStyle.backgroundColor = UIColor(hexString: "D6EDF6")
        self.selectedStyle.borderColor = UIColor(hexString: "3E8CB9")
        self.selectedStyle.borderWidth = 1
        self.selectedStyle.cornerRadius = 20
        self.selectedStyle.extraSpace = CGSize.init(width: 24, height: 20)
        
        self.tagCollection.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    // MARK: - RESET TAG
    func resetCell(typeTagSelected: TypeTagCollection) {
        switch typeTagSelected {
        case .days:
//            self.currentDaySelected = TagList(id: "", name: "", isChecked: false)
            self.currentDaysModel.removeAll()
        case .specializations:
//            self.currentSpecializationsSelected.removeAll()
            self.currentSpecializationsModel.removeAll()
        case .hospitals:
//            self.currentHospitalsSelected.removeAll()
            self.currentHospitalsModel.removeAll()
        case .prices:
//            self.currentPricesSelected.removeAll()
            self.currentPricesModel.removeAll()
        default:
            break
        }
        self.tagCollection.removeAllTags()
    }
    
    func setupDays(daySelected: FilterList, daysData: [DayName]) {
        if self.currentDaysModel.isEmpty {
            self.currentTypeTagSelected = .days
            
            if !daysData.isEmpty {
                // MARK: - ADD TO TAG CELL
                for day in daysData {
                    self.currentDaysModel.append(TagList(id: day.id, name: day.day, isChecked: false))
                }
                
                for (index, value) in self.currentDaysModel.enumerated() {
                    if index >= 7 { break }
                    
                    self.content = TTGTextTagStringContent.init(text: index == 0 ? "Hari ini" : value.name)
                    let tag = TTGTextTag.init()
                    tag.content = self.content
                    tag.style = self.configStyle
                    tag.selectedStyle = self.selectedStyle
                    
                    self.tagCollection.addTag(tag)
                    
                    // MARK: - MARK SELECTED TAG
                    if daySelected.id.lowercased() == value.id.lowercased() {
                        self.tagCollection.updateTag(at: UInt(index), selected: true)
                        
                    }
                }
                self.tagCollection.reload()
            }
        }
    }
    
    func setupSpecializations(tagSelected: [FilterList], specializationsData: [ListSpecialistModel]) {
        if self.currentSpecializationsModel.isEmpty {
            self.currentTypeTagSelected = .specializations
            
            var startIndex = 0
            
            // MARK: - ADD ALL DATA TO MODEL
            if !specializationsData.isEmpty {
                for indexData in specializationsData {
                    self.currentSpecializationsModel.append(
                        TagList(
                            id: indexData.specializationId ?? "",
                            name: indexData.name ?? "",
                            isChecked: false))
                }
                
                // MARK: - REMOVE SAME DATA AND ADD TO FIRST MODEL
                for (index, value) in self.currentSpecializationsModel.enumerated() {
                    for indexTag in tagSelected {
                        if indexTag.typeTag == .specializations && indexTag.id.lowercased() == value.id.lowercased() {

                            if indexTag.subFilter.isEmpty {
                                self.currentSpecializationsModel.remove(at: index)
                                
                                self.currentSpecializationsModel.insert(
                                    TagList(
                                        id: value.id,
                                        name: value.name,
                                        isChecked: indexTag.isChecked), at: startIndex)
                                startIndex += 1
                            } else {
                                if !indexTag.subFilter.isEmpty {
                                    for subValue in indexTag.subFilter {
                                        if subValue.isChecked {
                                            self.currentChildOfSpecializationsModel.append(TagList(
                                                id: subValue.id,
                                                name: subValue.name,
                                                isChecked: subValue.isChecked))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: - ADD CHILD DATA TO LAST OF SPECIALIZATION VIEW
                for index in self.currentChildOfSpecializationsModel {
                    self.currentSpecializationsModel.insert(index, at: startIndex)
                    startIndex += 1
                }
                
            }
            
            // MARK: - BUG : IF DATA IS EMPTY SELECTED
            if self.currentSpecializationsModel.isEmpty {
                for indexData in specializationsData {
                    self.currentSpecializationsModel.append(TagList(
                        id: indexData.specializationId ?? "",
                        name: indexData.name ?? "",
                        isChecked: false))
                }
            }
            
            for (index, value) in self.currentSpecializationsModel.enumerated() {
                if index >= 5 { break }
                
                let name = value.name
                
                self.content = TTGTextTagStringContent.init(text: name)
                let tag = TTGTextTag.init()
                tag.content = self.content
                tag.style = self.configStyle
                tag.selectedStyle = self.selectedStyle
                
                self.tagCollection.addTag(tag)
                
                // MARK: - UPDATE UI SELECTED DATA FIRST SHOW VIEW
                if !tagSelected.isEmpty && self.currentTypeTagSelected == .specializations {
                    if value.isChecked {
                        self.tagCollection.updateTag(at: UInt(index), selected: true)
                    }
                }
            }
            self.tagCollection.reload()
        }
        
    }
    
    func setupHospitals(tagSelected: [FilterList], hospitalsData: [ListHospitalModel]) {
        if self.currentHospitalsModel.isEmpty {
            self.currentTypeTagSelected = .hospitals
            
            var startIndex = 0
            // MARK: - ADD ALL DATA TO MODEL
            if !hospitalsData.isEmpty {
                for indexData in hospitalsData {
                    self.currentHospitalsModel.append(
                        TagList(
                            id: indexData.hospitalId ,
                            name: indexData.name ,
                            isChecked: false))
                }
                
                // MARK: - REMOVE SAME DATA AND ADD TO FIRST MODEL
                for (index, value) in self.currentHospitalsModel.enumerated() {
                    for indexTag in tagSelected {
                        if indexTag.typeTag == .hospitals && indexTag.id.lowercased() == value.id.lowercased() {
                            
                            self.currentHospitalsModel.remove(at: index)
                            
                            self.currentHospitalsModel.insert(
                                TagList(
                                    id: value.id,
                                    name: value.name,
                                    isChecked: true), at: startIndex)
                            startIndex += 1
                        }
                    }
                }
            }
            
            // MARK: - BUG : IF DATA IS EMPTY SELECTED
            if self.currentHospitalsModel.isEmpty {
                for indexData in hospitalsData {
                    self.currentHospitalsModel.append(TagList(
                        id: indexData.hospitalId ,
                        name: indexData.name ,
                        isChecked: false))
                }
            }
            
            for (index, value) in self.currentHospitalsModel.enumerated() {
                if index >= 5 { break }
                
                let id = value.id
                let name = value.name
                
                self.content = TTGTextTagStringContent.init(text: name)
                let tag = TTGTextTag.init()
                tag.content = self.content
                tag.style = self.configStyle
                tag.selectedStyle = self.selectedStyle
                
                self.tagCollection.addTag(tag)
                
                // MARK: - UPDATE UI SELECTED DATA FIRST SHOW VIEW
                if !tagSelected.isEmpty && self.currentTypeTagSelected == .hospitals {
                    for indexTag in tagSelected {
                        if indexTag.typeTag == .hospitals && indexTag.id.lowercased() == id.lowercased() {
                            self.tagCollection.updateTag(at: UInt(index), selected: true)
                        }
                    }
                }
            }
            self.tagCollection.reload()
        }
        
    }
    
    func setupPrices(tagSelected: [FilterList], pricesData: [ListPrice]) {
        if self.currentPricesModel.isEmpty {
            self.currentTypeTagSelected = .prices
            
            if !pricesData.isEmpty {
                for index in pricesData {
                    self.currentPricesModel.append(TagList(
                        id: index.idPrice ,
                        name: index.price ,
                        isChecked: false))
                }
                
                for (index, value) in self.currentPricesModel.enumerated() {
                    
                    if index >= 3 { break }
                    
                    self.content = TTGTextTagStringContent.init(text: value.name)
                    let tag = TTGTextTag.init()
                    tag.content = self.content
                    tag.style = self.configStyle
                    tag.selectedStyle = self.selectedStyle
                    
                    self.tagCollection.addTag(tag)
                    
                    // MARK: - UPDATE UI SELECTED DATA FIRST SHOW VIEW
                    if !tagSelected.isEmpty && self.currentTypeTagSelected == .prices {
                        for indexTag in tagSelected {
                            if indexTag.typeTag == .prices && indexTag.id.lowercased() == value.id.lowercased() {
                                self.tagCollection.updateTag(at: UInt(index), selected: true)
                            }
                        }
                    }
                    
                }
                self.tagCollection.reload()
    //            print("hasilnya adalah prices \(self.currentPricesSelected)")
            }
        }
    }
    
}

