//
//  ListAddressVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class ListAddressVC: UIViewController, ListAddressView {
    var onEditAddress: ((DetailAddressModel, String) -> Void)?
    var onAddNewAddres: (() -> Void)?

    var onSendStringAddress: ((String, String) -> Void)?
    var addressFix: String!
    
    var viewModel: ListAddressVM!
    @IBOutlet weak var viewAlertSuccess: UIView!
    @IBOutlet weak var imageCheckTrue: UIImageView!
    @IBOutlet weak var buttonCloseAlert: UIButton!
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tableViewListAddress: UITableView!
    @IBOutlet weak var buttonAddAlamat: UIButton!
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let deleteAddressRequest = BehaviorRelay<DeleteAddressBody?>(value: nil)
    private let requestSetAddress = BehaviorRelay<PrimaryAddressBody?>(value: nil)
    
    private lazy var listAddressOptionView : AddressOptionVC = {
        let vc = AddressOptionVC()
        vc.delegate = self
        return vc
    }()
    
    var idSelected : String?
    var isRoot : Bool!
    
    private var modelAddress = [DetailAddressModel]() {
        didSet{
            self.tableViewListAddress.reloadData()
        }
    }
    
    var modelSelected : DetailAddressModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupNavigation()
        self.registerTableView()
        self.viewDidLoadRelay.accept(())
        self.setupActiveButton(button: buttonAddAlamat)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoadRelay.accept(())
        self.tableViewListAddress.reloadData()
    }

    func bindViewModel() {
        let input = ListAddressVM.Input(deleteAddressInput: self.deleteAddressRequest.asObservable(), setDefaultAddressInput: self.requestSetAddress.asObservable(), viewDidLoadRelay: self.viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.listAddressOuput.drive { (data) in
            self.modelAddress = data
        }.disposed(by: self.disposeBag)
    }
    
    func setupNavigation (){
        if isRoot {
            self.setTextNavigation(title: "Daftar Alamat", navigator: .close)
        } else {
            self.setTextNavigation(title: "Daftar Alamat", navigator: .back)
        }
    }
    
    func registerTableView(){
        self.tableViewListAddress.delegate = self
        self.tableViewListAddress.dataSource = self
        
        let nib = UINib(nibName: "DaftarAlamatTVCell", bundle: nil)
        self.tableViewListAddress.register(nib, forCellReuseIdentifier: "daftarAlamatCell")
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {
        self.onAddNewAddres?()
    }
}

extension ListAddressVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daftarAlamatCell", for: indexPath) as! ListAddressTVCell
        let modelTarget = modelAddress[indexPath.row]
        cell.setupData(data: modelTarget)
        cell.delegate = self
        return cell
    }
    
    
}

extension ListAddressVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daftarAlamatCell", for: indexPath) as! ListAddressTVCell
        let modelTarget = modelAddress[indexPath.row]
        let completeAddress = "\(modelTarget.street) \(modelTarget.rtRw) \(modelTarget.subDistrict) \(modelTarget.district) \(modelTarget.city) \(modelTarget.province)"
        self.onSendStringAddress?(modelTarget.id, completeAddress)
    }
}

extension ListAddressVC : AddressOptionDelegate{
    func deleteAddress(id: String) {
        idSelected = id
        self.deleteAddressRequest.accept(DeleteAddressBody(id: idSelected ?? ""))
    }
    
    func changeToPrimaryAddress(id : String) {
        ///dismise drawer hit
        ///change primary address
        idSelected = id
        self.requestSetAddress.accept(PrimaryAddressBody(id: idSelected ?? ""))
    }
    
    
    
}

extension ListAddressVC : ListAddressTVCellDelegate{
    func editAddress(data: DetailAddressModel, idSelected : String) {
        self.modelSelected = data
        self.idSelected = idSelected
        self.onEditAddress?(self.modelSelected ?? data, self.idSelected ?? "")
        print("id kirim : \(self.idSelected)")
    }
    
    func option(id: String) {
        idSelected = id
        listAddressOptionView.idAddress = idSelected
        presentPanModal(listAddressOptionView)
    }
    
}
