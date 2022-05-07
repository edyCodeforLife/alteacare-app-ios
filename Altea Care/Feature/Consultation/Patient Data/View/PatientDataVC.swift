//
//  PatientDataVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import Photos
import PDFKit
import MobileCoreServices
import Kingfisher
import PanModal

class PatientDataVC: UIViewController, IndicatorInfoProvider, PatientDataView {
    var onConsultationCallingTapped: ((Int, String) -> Void)?
    var onCountdownShow: ((Schedule) -> Void)?
    var onConsultation: ((String, Bool) -> Void)?
    var viewModel: PatientDataVM!
    var status: ConsultationStatus!
    var timer: Timer!
    private let disposeBag = DisposeBag()
    private var model: PatientDataModel? = nil
    
    var id: String! {
        didSet {
            
        }
    }
    
    private var tableViewItems: [Attachment] = [Attachment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var imagePickerHandler = ImagePickerHandler(sourceType: .photoLibrary)
    lazy var filePickerHandler = FilePickerHandler()
    private lazy var attachPicker: AttachPickerVC = {
        let vc = AttachPickerVC()
        vc.delegate = self
        return vc
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doctorCard: DoctorCard!
    @IBOutlet weak var dateTimeBar: DateTimeBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: FormRow!
    @IBOutlet weak var age: FormRow!
    @IBOutlet weak var birthday: FormRow!
    @IBOutlet weak var sex: FormRow!
    @IBOutlet weak var idCard: FormRow!
    @IBOutlet weak var phone: FormRow!
    @IBOutlet weak var email: FormRow!
    @IBOutlet weak var address: FormTextView!
    @IBOutlet weak var patientContainer: UIView!
    @IBOutlet weak var dataPasienTitle: ACLabel!
    @IBOutlet weak var button: ACButton!
    
    private let idRelay = BehaviorRelay<String?>(value:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        //        self.setupTableView()
        self.bindViewModel()
        self.idRelay.accept(self.id)
    }
    
    func bindViewModel() {
        let input = PatientDataVM.Input(fetch: idRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.scrollView.refreshControl?.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.patientData.drive { (model) in
            self.model = model
            self.setForm(model)
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Data Pasien")
    }
    
    private func setupUI() {
        self.patientContainer.layer.cornerRadius = 5
        self.patientContainer.layer.masksToBounds = true
        self.name.clipsToBounds = true
        self.setupRefresh()
        self.button.set(type: .filled(custom: .info), title: "Menunggu Telekonsultasi")
    }
    
    private func setupRefresh() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        self.idRelay.accept(self.id)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "AttachFileCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AttachFileCell")
        let nibed = UINib(nibName: "AttachedFileCell", bundle: nil)
        self.tableView.register(nibed, forCellReuseIdentifier: "AttachedFileCell")
    }
    
    
    private func setForm(_ model: PatientDataModel?) {
        
        
        guard let model = model else { return }
        
        if (model.doctor?.doctorImage?.isEmpty)! || model.doctor?.doctorImage! == "-" {
            self.doctorCard.image.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: model.doctor?.doctorImage ?? ""){
                self.doctorCard.image.kf.setImage(with: urlPhotoPerson)
            }
        }
        
        if (model.doctor?.hospitalIcon?.isEmpty)! || model.doctor?.hospitalIcon! == "-" {
            self.doctorCard.hospitalIcon.image = UIImage(named: "IconMitraKeluarga")
        } else {
            if let urlPhotoHospital = URL(string: model.doctor?.hospitalIcon ?? ""){
                self.doctorCard.hospitalIcon.kf.setImage(with: urlPhotoHospital)
            }
        }
        
        self.doctorCard.hospitalName.text = model.doctor?.hospitalName
        self.doctorCard.name.text = model.doctor?.name
        self.doctorCard.profession.text = model.doctor?.specialty
        self.dateTimeBar.leftIcon.tintColor = .alteaDark3
        self.dateTimeBar.leftLabel.text = model.doctor?.date?.dateIndonesiaStandard()
        self.dateTimeBar.leftLabel.textColor = .alteaDark3
        self.dateTimeBar.rightIcon.tintColor = .alteaDark3
        self.dateTimeBar.rightLabel.text = model.doctor?.time
        self.dateTimeBar.rightLabel.textColor = .alteaDark3
        
        self.name.title.text = "Nama"
        self.name.value.text = model.name
        self.age.title.text = "Umur"
        self.age.value.text = model.age
        self.birthday.title.text = "Tanggal Lahir"
        self.birthday.value.text = model.birthday.getIndonesianDateString()
        self.sex.title.text = "Jenis Kelamin"
        self.sex.value.text = model.sex
        self.idCard.title.text = "No. KTP"
        self.idCard.value.text = model.idCard
        self.phone.title.text = "No. Telepon"
        self.phone.value.text = model.phone
        self.email.title.text = "Email"
        self.email.value.text = model.email
        self.address.title.text = "Alamat"
        self.address.value.text = model.address
        
        let status =  self.model?.status
        if status == .meetTheDoctor {
           showButton()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            self.button.onTapped = {
                guard let schedule = model.schedule else {return}
                if schedule.isConsultationStarted() {
                    guard let appointment = model.appointment else {return}
                    self.onConsultationCallingTapped?(appointment.id, appointment.orderCode)
                } else {
                    self.onCountdownShow?(schedule)
                }
            }
        } else if status == .done {
            showButton()
            self.button.set(type: .filled(custom: .primary), title: "Jadwalkan Ulang")
            self.button.onTapped = {
                self.onConsultation?(model.doctor?.id ?? "", false)
            }
        } else if status == .meetSpecialist {
            showButton()
            self.button.setTitle(title: "Temui Dokter")
            self.button.onTapped = {
                guard let appointment = model.appointment else {return}
                self.onConsultationCallingTapped?(appointment.id, appointment.orderCode)
            }
        }
    }
    
    private func showButton() {
        self.button.isHidden = false
        self.button.clipsToBounds = true
    }
    
    @objc func UpdateTime() {
        guard let schedule = model?.schedule else {
            timer.invalidate()
            return
        }
        self.button.setTitle(title:  "Mulai Telekonsultasi \(schedule.getCountDownLabel())")
        if(schedule.isConsultationStarted()) {
            timer.invalidate()
            self.button.setTitle(title: "Temui Dokter")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.model?.status.label == "Temui dokter" {
            timer.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.model?.status.label == "Temui dokter" {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
        }
        
    }
    
}

enum Attachment {
    case upload
    case files(Files)
}

extension PatientDataVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = 1
        self.tableHeightConstraint.constant = CGFloat(45 * numberOfRows)
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "AttachFileCell", for: indexPath)  as! AttachFileCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AttachedFileCell", for: indexPath)  as! AttachedFileCell
        let totalRow = tableView.numberOfRows(inSection: 0)
        if indexPath.row == totalRow - 1 {
            cell1.attachFileBar.attachFile.addTapGestureRecognizer {
                self.presentPanModal(self.attachPicker)
            }
            return cell1
        } else {
            return cell2
        }
        
    }
    
    
}

extension PatientDataVC: UITableViewDelegate {
    
}

extension PatientDataVC: AttachmentPickerDelegate{
    func gallerySelected() {
        self.presentMediaPicker(fromController: self, sourceType: .photoLibrary)
    }
    
    func camSelected() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.presentMediaPicker(fromController: self, sourceType: .camera)
        }
        else
        {
            showBasicAlert(title: "Error", message: "Tidak ada kamera!", completion: nil)
            
        }
    }
    
    func docSelected() {
        self.presentFilePicker(fromController: self)
    }
}

extension PatientDataVC: MediaPickerPresenter, FilePickerPresenter {
    func didSelectFromFilePicker(withUrl fileUrl: URL) {
        // ...
    }
    
    func didSelectFromMediaPicker(withImage image: UIImage) {
        // ...
    }
    
    func didSelectFromMediaPicker(withMediaUrl mediaUrl: NSURL) {
        // ...
    }
}

extension PatientDataVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // ...
    }
}
