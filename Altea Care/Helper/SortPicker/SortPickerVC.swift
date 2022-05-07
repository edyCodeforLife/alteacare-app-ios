//
//  SortPickerVC.swift
//  Altea Care
//
//  Created by Admin on 26/3/21.
//

import UIKit
import PanModal

protocol SortPickerDelegate: NSObject {
    // MARK: - OLD
    func popularitySelected()
    func priceSelected()
    func experienceSelected()
    
    // MARK: - NEW
    func priceHighLow()
    func priceLowHigh()
    func experienceOldestNewest()
    func experienceNewestOldest()
    func didSelect(_ picker: SortPickerVC, index: Int)
}

class SortPickerVC: UIViewController, PanModalPresentable, AMChoiceDelegate {
    
    weak var delegate: SortPickerDelegate?
    
    var panScrollable: UIScrollView?
    
    var isShortFormEnabled = true
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(250)
    }
    
    var longFormHeight: PanModalHeight {
        .contentHeight(250)
    }
    
    @IBOutlet weak var amChoiceView: AMChoice!
    @IBOutlet weak var submitButton: ACButton!
    
    let myItems = [
        //            VoteModel(title: "Paling Populer", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Harga (Tertinggi - Terendah)", isSelected: true, isUserSelectEnable: true),
        VoteModel(title: "Pengalaman (Terlama - Terbaru)", isSelected: false, isUserSelectEnable: true),
    ]
    var items = [VoteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRadio()
        submitButton.set(type: .filled(custom: .alteaMainColor), title: "Submit")
    }
    
    private func setupRadio(){
        amChoiceView.delegate = self // the delegate used to get the selected item when pressed
        
        amChoiceView.data = items // fill your item , the item may come from server or static in your code like i have done
        
        amChoiceView.selectionType = .single // selection type , single or multiple
        
        amChoiceView.cellHeight = 45 // to set cell hight
        
        amChoiceView.arrowImage = nil // use ot if you want to add arrow to the cell
    }
    
    
    func didSelectRowAt(indexPath: IndexPath) {
        submitButton.set(type: .filled(custom: .alteaMainColor), title: "Submit")
        submitAction(index: indexPath.row)
    }
    
    private func submitAction(index: Int) {
        self.submitButton.onTapped = {
            let selectedItems = self.amChoiceView.getSelectedItems() as! [VoteModel] // use getSelectedItems to get all selected item
            print(selectedItems)
            
            let selectedItemCommaSeparated = self.amChoiceView.getSelectedItemsJoined(separator: ",") // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
            print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
            
            // PILIH SALAH SATU UNTUK MASA DEPAN
            if index == 0 {
                self.delegate?.priceHighLow()
                self.delegate?.priceSelected()
            }else if index == 1 {
                self.delegate?.experienceOldestNewest()
                self.delegate?.experienceSelected()
            } else {
                
            }
            self.delegate?.didSelect(self, index: index)

            self.dismiss(animated: true, completion: nil)
        }
    }
}

class VoteModel: NSObject, Selectable {
    var title: String
    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true
    
    init(title:String,isSelected:Bool,isUserSelectEnable:Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
    }
}
