//
//  ListMemberVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 22/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class ListMemberVC: UIViewController, ListMemberView {
    var onCreateNewFamilyMember: (() -> Void)?
    var onDetailMember: ((MemberModel) -> Void)?
    var onMakeAsMainAccount: (() -> Void)?
    
    @IBOutlet weak var tableViewProfileUtama: UITableView!
    @IBOutlet weak var labelProfilUtama: UILabel!
    @IBOutlet weak var viewEmptyState: UIView!
    @IBOutlet weak var tableViewOtherProfile: UITableView!
    @IBOutlet weak var labelOtherProfile: UILabel!
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    @IBOutlet weak var labelFamilyListIsEmpty: UILabel!
    @IBOutlet weak var labelToCreateNewMember: UILabel!
    @IBOutlet weak var buttonAddMember: UIButton!
    @IBOutlet weak var containerButtonView: UIView!
    @IBOutlet weak var containerIsEmptyCell: UIView!
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let defaultMemberRequest = BehaviorRelay<SetDefaultMemberBody?>(value: nil)
    private let disposeBag = DisposeBag()
    var viewModel: ListMemberVM!
    var isReadOnly: Bool!
    
    var selectedID: String?
    
    private lazy var memberOptionView: MemberProfileOptionVC = {
        let vc = MemberProfileOptionVC()
        vc.delegate = self
        return vc
    }()
    
    private var modelOtherMember = [MemberModel]() {
        didSet{
            var data = (Dictionary(grouping: modelOtherMember, by: { $0.isMainProfile})).map { $0.value }
            if ((data.first?.first(where: { $0.isMainProfile == false})) != nil){
                data.swapAt(0, 1)
            }
            memberFiltered = data
        }
    }
    
    var memberFiltered = [[MemberModel]](){
        didSet{
            if self.viewIfLoaded?.window != nil {
                self.tableViewOtherProfile.reloadData()
            }
        }
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bindViewModel()
        self.registerTableView()
        self.setupNavigation()
        self.setupActiveButton(button: buttonAddMember)
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoadRelay.accept(())
        selectedID = nil
    }
    
    func bindViewModel() {
        let input = ListMemberVM.Input(viewDidloadRelay: self.viewDidLoadRelay.asObservable(),
                                       defaultMemberRequest: self.defaultMemberRequest.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.listMemberOutput.drive{ (listMember) in
            //            self.model = listMember
            self.modelOtherMember = listMember
        }.disposed(by: self.disposeBag)
    }
    
    func registerTableView(){
        self.tableViewProfileUtama.delegate = self
        self.tableViewProfileUtama.dataSource = self
        
        self.tableViewOtherProfile.delegate = self
        self.tableViewOtherProfile.dataSource = self
        
        let nib = UINib(nibName: "MemberCell", bundle: nil)
        self.tableViewProfileUtama.register(nib, forCellReuseIdentifier: "listFamilyCell")
        self.tableViewOtherProfile.register(nib, forCellReuseIdentifier: "listFamilyCell")
        tableViewProfileUtama.registerNIB(with: MemberChooseCell.self)
        tableViewOtherProfile.registerNIB(with: MemberChooseCell.self)
    }
    
    func setupNavigation (){
        self.setTextNavigation(title: "List Daftar Keluarga", navigator: .close)
    }
    
    @IBAction func buttonCreateTapped(_ sender: Any) {
        self.onCreateNewFamilyMember?()
    }
}

extension ListMemberVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = memberFiltered[indexPath.section]
        let dataSection = section[indexPath.row]
        
        self.onDetailMember?(dataSection)
    }
}

extension ListMemberVC : UITableViewDataSource{
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return memberFiltered.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = memberFiltered[section].count
        if rows == 0{
            self.containerIsEmptyCell.isHidden = false
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isReadOnly{
            guard let cell = tableView.dequeueCell(with: MemberChooseCell.self) else {
                return UITableViewCell()}
            let section = memberFiltered[indexPath.section]
            let dataSection = section[indexPath.row]
            cell.profileNameLabel.text = dataSection.name
            cell.profileRoleLabel.text = dataSection.role
            cell.selectionStyle = .none
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listFamilyCell", for: indexPath) as? MemberCell else {return UITableViewCell()}
            
            let section = memberFiltered[indexPath.section]
            let modelOtherTarget = section[indexPath.row]
            cell.data = modelOtherTarget
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension ListMemberVC : MemberCellDelegate{
    func option(id: String){
        selectedID = id
        presentPanModal(memberOptionView)
    }
}

extension ListMemberVC : MemberProfileOptionDelegate{
    func profileToAcc(id: String) {
        //put id here
        defaultMemberRequest.accept(SetDefaultMemberBody(id: selectedID ?? ""))
    }
}

