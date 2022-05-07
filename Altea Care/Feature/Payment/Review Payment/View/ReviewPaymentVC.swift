//
//  ReviewPaymentVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewPaymentVC: UIViewController, ReviewPaymentView {
    @IBOutlet weak var seeMyConsultB: ACButton!
    @IBOutlet weak var toHomeB: ACButton!
    @IBOutlet weak var orderIDL: UILabel!
    @IBOutlet weak var doctorIV: UIImageView!
    @IBOutlet weak var hospitalIV: UIImageView!
    @IBOutlet weak var hospitalNameL: UILabel!
    @IBOutlet weak var doctorNameL: UILabel!
    @IBOutlet weak var specializarionL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var totalPriceL: UILabel!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var voucherAmountLabel: UILabel!
    @IBOutlet weak var voucherView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerNIB(with: PaymentInqFeeCell.self)
        }
    }
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    var isRoot: Bool = false
    var viewModel: ReviewPaymentVM!
    var onPaymentReviewed: (() -> Void)?
    var appointmentId: Int!
    var goDashboard: (() -> Void)?
    
    private let requestDetailAppointmentRelay = BehaviorRelay<DetailAppointmentBody?>(value: nil)
    
    var model : ReviewPaymentModel?{
        didSet{
            guard let fees = self.model?.fees else {return}
            feeDatas = fees
        }
    }
    
    var feeDatas : [InquiryPaymentFeeModel] = []{
        didSet{
            tableViewHeight.constant = CGFloat(feeDatas.count * 20)
            view.layoutIfNeeded()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButton()
        self.setupTable()
        self.setupNavigation()
        self.bindViewModel()
        self.requestDetailAppointmentRelay.accept(DetailAppointmentBody(appointment_id: appointmentId))
    }
    
    func bindViewModel() {
        let input = ReviewPaymentVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), detailAppointmentRelay: requestDetailAppointmentRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        
        output.appointmentDetailState.drive { (reviewData) in
            self.model = reviewData
            self.setupData(model: reviewData)
        }.disposed(by: self.disposeBag)
    }
    
    func setupNavigation() {
        self.setTextNavigation(title: "Pembayaran", navigator: .close, navigatorCallback: #selector(onCloseAction))
    }
    
    @objc private func onCloseAction() {
        self.onPaymentReviewed?()
    }
    
    func setupData(model : ReviewPaymentModel?){
        self.hospitalIV.image = #imageLiteral(resourceName: "Image and Icon")
        dateL.text = model?.doctor?.date?.dateIndonesiaStandard()
        timeL.text = model?.doctor?.time
        self.totalPriceL.text = ("\((model?.total ?? 0).toCurrency())")
        self.specializarionL.text = model?.doctor?.specialty
        doctorNameL.text = model?.doctor?.name
        hospitalNameL.text = model?.doctor?.hospitalName
        orderIDL.text = "Order ID : \(model?.orderCode ?? "")"
        
        if (model?.doctor?.hospitalIcon?.isEmpty)! || model?.doctor?.hospitalIcon! == "-" {
            self.hospitalIV.image = UIImage(named: "IconMitraKeluarga")
        } else {
            if let urlPhotoHospital = URL(string: model?.doctor?.hospitalIcon ?? ""){
                self.hospitalIV.kf.setImage(with: urlPhotoHospital)
            }
        }
        
        if (model?.doctor?.doctorImage?.isEmpty)! || model?.doctor?.doctorImage! == "-" {
            self.doctorIV.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: model?.doctor?.doctorImage ?? ""){
                self.doctorIV.kf.setImage(with: urlPhotoPerson)
            }
        }
    }
    
    private func setupButton(){
        seeMyConsultB.set(type: .filled(custom: nil), title: "Lihat Telekonsultasi Saya")
        seeMyConsultB.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onPaymentReviewed?()
        }
        
        toHomeB.set(type: .bordered(custom: nil), title: "Ke Beranda")
        toHomeB.onTapped = { [weak self] in
            guard let self = self else { return }
            self.goDashboard?()
        }
    }
    
    private func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNIB(with: PaymentInqFeeCell.self)
    }
}

extension ReviewPaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: PaymentInqFeeCell.self) else {
            return UITableViewCell()
        }
        
        cell.feeTitleL.text = feeDatas[indexPath.row].name ?? ""
        cell.feeL.text = feeDatas[indexPath.row].price
        return cell
    }
    
}

