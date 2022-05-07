//
//  FamilyMemberOptionVC.swift
//  Altea Care
//
//  Created by Tiara on 25/08/21.
//

import UIKit
import PanModal

protocol FilterMemberDelegate : AnyObject{
    func memberChoosed(idMember: String, isMainProfile: Bool) // change the string to member object
}

class FamilyMemberOptionVC: UIViewController, PanModalPresentable {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate =  self
            tableView.registerNIB(with: FamilyMemberItemCell.self)
        }
    }
    
    weak var delegate: FilterMemberDelegate?
    var isShortFormEnabled = true
    var panScrollable: UIScrollView?
    var shortFormHeight: PanModalHeight{
        .contentHeight(300.0)
    }
    var showDragIndicator: Bool {
        return false
    }
    
    var listMember: [MemberModel] = []{
        didSet{
            if self.viewIfLoaded?.window != nil {
                tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension FamilyMemberOptionVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: FamilyMemberItemCell.self) else {
            return UITableViewCell()}
        let data = listMember[indexPath.row]
        cell.roleAndNameLabel.text = "\(data.role) - \(data.name)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = listMember[indexPath.row]
        dismiss(animated: true, completion: nil)
        delegate?.memberChoosed(idMember: data.idMember, isMainProfile: data.isMainProfile)
    }
}
