//
//  InquiryPaymentVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa

enum AlteaStepType{
    case previous
    case current
    case next
}

let VoucherNotificationName = "ReceiveDataVoucher"

class InquiryPaymentVC: UIViewController, InquiryPaymentView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderIDL: UILabel!
    @IBOutlet weak var doctorIV: UIImageView!
    @IBOutlet weak var hospitalIV: UIImageView!
    @IBOutlet weak var hospitalNameL: UILabel!
    @IBOutlet weak var doctorNameL: UILabel!
    @IBOutlet weak var specializarionL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var totalPriceL: UILabel!
    @IBOutlet weak var paymentMethodButton: ACButton!
    @IBOutlet weak var deleteVoucherView: UIView!
    @IBOutlet weak var applyVoucherView: UIView!
    @IBOutlet weak var voucherAppliedLabel: UILabel!
    @IBOutlet weak var voucherNominalLabel: UILabel!
    
    var viewModel: InquiryPaymentVM!
    var onInquiry: ((Int) -> Void)?
    var onClosed: (() -> Void)?
    var onMethodTapped: ((Int, VoucherBody?) -> Void)?
    var consultationId: String!
    var onApplyVoucher: ((String) -> Void)?
    
    private let disposeBag = DisposeBag()
    private var model: InquiryPaymentModel? = nil{
        didSet{
            tableViewHeight.constant = CGFloat((model?.fees.count ?? 0) * 20)
            tableView.reloadData()
        }
    }
    private let idRelay = BehaviorRelay<String?>(value:nil)
    private var voucherApplied = BehaviorRelay<VoucherBody?>(value:nil)
    
    var voucherUsed : VoucherModel?{
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                guard let voucher = self.voucherUsed?.voucher else {return}
                self.updateVoucher(v: voucher)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        idRelay.accept(self.consultationId)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onReceiveData),
                                               name: NSNotification.Name(rawValue: VoucherNotificationName),
                                               object: nil)
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func bindViewModel() {
        let input = InquiryPaymentVM.Input(fetch: idRelay.asObservable())
        
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        
        output.state.drive { (_) in
            self.scrollView.refreshControl?.endRefreshing()
            
            self.setForm(self.model)
        }.disposed(by: self.disposeBag)
        
        output.inquiryPayment.drive { (model) in
            self.model = model
            self.setForm(model)
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupNavigation()
        setupButton()
        setupCollectionView()
        setupTable()
        setupRefresh()
    }
    
    private func setupRefresh() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        self.idRelay.accept(self.consultationId)
    }
    
    private func setupNavigation() {
        self.setTextNavigation(title: "Pembayaran", navigator: .close, navigatorCallback: #selector(onCloseAction))
        
    }
    
    private func setupButton(){
        paymentMethodButton.set(type: .filled(custom: nil), title: "    Pilih Metode Pembayaran", titlePosition: .left, icon: UIImage(named: "ic-arrow-white"), iconPosition: .right)
        paymentMethodButton.onTapped = {
            [weak self] in
            guard let self = self else { return }
            self.voucherApplied.accept(VoucherBody(code: self.voucherUsed?.voucher?.voucherCode ?? "", transaction_id: self.model?.id ?? "", type_of_service: "TELEKONSULTASI"))
            let request = VoucherBody(code: self.voucherUsed?.voucher?.voucherCode ?? "", transaction_id: self.model?.id ?? "", type_of_service: "TELEKONSULTASI")
            self.onMethodTapped?(Int(self.model?.id ?? "0") ?? 0, self.voucherApplied.value)
        }
    }
    
    private func setupCollectionView(){
        let cellNib = UINib(nibName: "StepBookingCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "stepBookingCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.isPagingEnabled = false
        self.collectionView.isPagingEnabled = true
        
        let flowDayLayout = UICollectionViewFlowLayout()
        flowDayLayout.minimumLineSpacing = 4.0
        flowDayLayout.itemSize = CGSize(width: 220, height: 30)
        flowDayLayout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = flowDayLayout
    }
    
    private func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNIB(with: PaymentInqFeeCell.self)
    }
    
    func updateVoucher(v: VoucherData){
        voucherAppliedLabel.text = v.voucherCode
        voucherNominalLabel.text = v.discount.formatted
        totalPriceL.text = v.afterDiscountPrice.formatted
        deleteVoucherView.isHidden = false
        applyVoucherView.isHidden = true
        voucherApplied.accept(VoucherBody(code: v.voucherCode, transaction_id: self.model?.id ?? "", type_of_service: "TELEKONSULTASI"))
    }
    
    private func setForm(_ model: InquiryPaymentModel?) {
        guard let model = model else { return }
        
        if (model.doctor?.doctorImage ?? "").isEmpty || model.doctor?.doctorImage! == "-" {
            self.doctorIV.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: model.doctor?.doctorImage ?? ""){
                self.doctorIV.kf.setImage(with: urlPhotoPerson)
            }
        }
        
        if (model.doctor?.hospitalIcon?.isEmpty)! || model.doctor?.hospitalIcon! == "-" {
            self.hospitalIV.image = UIImage(named: "IconMitraKeluarga")
        } else {
            if let urlPhotoHospital = URL(string: model.doctor?.hospitalIcon ?? ""){
                self.hospitalIV.kf.setImage(with: urlPhotoHospital)
            }
        }
        
        orderIDL.text = "Order ID : \(model.code ?? "")"
        doctorNameL.text = model.doctor?.name
        hospitalNameL.text = model.doctor?.hospitalName
        specializarionL.text = model.doctor?.specialty
        dateL.text = model.doctor?.date?.dateIndonesiaStandard()
        timeL.text = model.doctor?.time
        totalPriceL.text = model.total?.toCurrency()
        
    }
    
    // MARK: - Buttons Action
    
    @objc func onReceiveData(_ notification:Notification) {
        
    }
    
    @objc private func onCloseAction() {
        self.onClosed?()
    }
    
    @IBAction func useVoucherTapped(_ sender: Any) {
        //        self.onApplyVoucher?(self.idRelay.value ?? "")
        self.onApplyVoucher?(self.model?.id ?? "0")
    }
    
    @IBAction func voucherDeleteTapped(_ sender: Any) {
        deleteVoucherView.isHidden = true
        applyVoucherView.isHidden = false
        totalPriceL.text = (model?.total ?? 0).toCurrency()
        voucherApplied.accept(nil)
    }
}

extension InquiryPaymentVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "stepBookingCell", for: indexPath) as! StepBookingCollectionViewCell
        
        if indexPath.row == 0{
            cell.labelStepNumber.text = "\(indexPath.row + 1)"
            cell.labelStepTitle.text = "Konfirmasi"
            cell.containerView.backgroundColor =  UIColor.alteaDarker
            cell.viewLine.backgroundColor = UIColor.alteaDarker
            cell.labelStepTitle.textColor = UIColor.alteaDarker
        }
        else if indexPath.row == 1{
            cell.labelStepNumber.text = "\(indexPath.row + 1)"
            cell.labelStepTitle.text = "Bayar"
            cell.containerView.backgroundColor = UIColor.alteaBlueMain
            cell.viewLine.backgroundColor = UIColor.alteaBlueMain
            cell.labelStepTitle.textColor = UIColor.alteaBlueMain
            
        }else if indexPath.row == 2{
            cell.labelStepNumber.text = "\(indexPath.row + 1)"
            cell.labelStepTitle.text = "Telekonsultasi dibuat"
            cell.containerView.backgroundColor = UIColor.alteaDark3
            cell.viewLine.backgroundColor = UIColor.alteaDark3
            cell.labelStepTitle.textColor = UIColor.alteaDark3
        }
        return cell
    }
}

extension InquiryPaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.fees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: PaymentInqFeeCell.self) else {
            return UITableViewCell()
        }
        guard let data = model?.fees[indexPath.row] else {return UITableViewCell()}
        cell.feeTitleL.text = data.name ?? ""
        cell.feeL.text = data.price
        return cell
    }
}

