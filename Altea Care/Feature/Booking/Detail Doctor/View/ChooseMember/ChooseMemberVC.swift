//
//  ChooseMemberVC.swift
//  Altea Care
//
//  Created by Tiara on 25/08/21.
//

import UIKit
import PanModal

protocol ChooseMemberDelegate : AnyObject{
    func memberChoosed(member: MemberModel) // change the string to member object
    func goToAddMember()
}

class ChooseMemberVC: UIViewController, PanModalPresentable {
    @IBOutlet weak var addFamilyButton: ACButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate =  self
            tableView.registerNIB(with: MemberChooseCell.self)
        }
    }
    
    var members = [MemberModel](){
        didSet{
            var data =   (Dictionary(grouping: members, by: { $0.isMainProfile})).map {  $0.value}
            if ((data.first?.first(where: { $0.isMainProfile == false})) != nil){
                data.swapAt(0, 1)
            }
            memberFiltered = data
        }
    }
    
    var memberFiltered = [[MemberModel]](){
        didSet{
            if self.viewIfLoaded?.window != nil {
                tableView.reloadData()
            }
        }
    }
    
    weak var delegate: ChooseMemberDelegate?
    
    var isShortFormEnabled = false
    var panScrollable: UIScrollView?
    var shortFormHeight: PanModalHeight{
        .maxHeight
    }
    var showDragIndicator: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFamilyButton.set(type: .filled(custom: .alteaMainColor), title: "+ Tambah Daftar Keluarga")
        addFamilyButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.goToAddMember()
        }
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        // Do any additional setup after loading the view.
    }
    
    func updateModels(members: [MemberModel]){
        self.members = members
    }
}

extension ChooseMemberVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return memberFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = section == 0 ? "Profil Pribadi" : "Profil Lainnya"
        label.font = UIFont(name: "Inter-SemiBold", size: 14.0)
        label.textColor = .alteaDark1

        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = memberFiltered[section].count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: MemberChooseCell.self) else {
            return UITableViewCell()}
        let section = memberFiltered[indexPath.section]
        let dataSection = section[indexPath.row]
        cell.profileNameLabel.text = dataSection.name
        cell.profileRoleLabel.text = dataSection.role
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = memberFiltered[indexPath.section]
        let dataSection = section[indexPath.row]
        dismiss(animated: true, completion: nil)
        delegate?.memberChoosed(member: dataSection)
    }
}
