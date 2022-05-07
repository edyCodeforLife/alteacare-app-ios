//
//  GenderPickerVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import UIKit
import PanModal

protocol GenderPickerDelegate : NSObject {
    func maleSelected()
    func femaleSelected()
}

class GenderPickerVC: UIViewController, PanModalPresentable, AMChoiceDelegate {
    
    weak var delegate : GenderPickerDelegate?
    
    var panScrollable: UIScrollView?
    
    var isShortFormEnabled = true
    
    @IBOutlet weak var genderOption: AMChoice!
    @IBOutlet weak var buttonSelect: ACButton!
    
    let genderItems = [
        GenderModel(title: "Laki-laki", isSelected: false, isUserSelectEnable: true),
        GenderModel(title: "Perempuan", isSelected: false, isUserSelectEnable: true)
    ]
    
    var showDragIndicator: Bool{
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(300.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRadio()
        buttonSelect.set(type: .disabled, title: "Pilih")
        
    }
    
    private func setupRadio(){
        genderOption.delegate = self // the delegate used to get the selected item when pressed
                
        genderOption.data = genderItems // fill your item , the item may come from server or static in your code like i have done
                
        genderOption.selectionType = .single // selection type , single or multiple
                
        genderOption.cellHeight = 45 // to set cell hight
                
        genderOption.arrowImage = nil // use ot if you want to add arrow to the cell
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        buttonSelect.set(type: .filled(custom: .alteaMainColor), title: "Submit")
        submitAction(index: indexPath.row)
        
      }
    
//    @IBAction func submit(_ sender: Any) {
//        let selectedItems = amChoiceView.getSelectedItems() as! [VoteModel] // use getSelectedItems to get all selected item
//        print(selectedItems)
//
//        let selectedItemCommaSeparated = amChoiceView.getSelectedItemsJoined(separator: ",") // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
//        print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
//      }
    
    private func submitAction(index: Int) {
        self.buttonSelect.onTapped = {
            let selectedItems = self.genderOption.getSelectedItems() as! [VoteModel] // use getSelectedItems to get all selected item
            print(selectedItems)

            let selectedItemCommaSeparated = self.genderOption.getSelectedItemsJoined(separator: ",") // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
            print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
            
            if index == 0 {
                self.delegate?.maleSelected()
            }else if index == 1 {
                self.delegate?.femaleSelected()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

}

class GenderModel : NSObject, Selectable {
    var title : String
    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true
    
    init(title : String, isSelected : Bool, isUserSelectEnable : Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
    }
}
