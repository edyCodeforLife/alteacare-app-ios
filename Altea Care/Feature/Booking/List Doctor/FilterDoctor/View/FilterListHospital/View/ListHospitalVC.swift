//
//  ListHospitalVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import UIKit
import PanModal

protocol ListHospitalDelegate : NSObject {
    func selectHospital(id : String, nameHospital : String)
}

class ListHospitalVC: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var containerSearchBar: CardView!
    @IBOutlet weak var listHospitalTableView: UITableView!
    var showDragIndicator: Bool {
        return false
    }
    
    weak var delegate : ListHospitalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
