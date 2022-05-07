//
//  CreateBookingVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import DLRadioButton
import PanModal
class CreateBookingVC: UIViewController, CreateBookingView {
    
    var changeDoctorTapped: (() -> Void)?
    var changePatientDataTapped: ((String, String) -> Void)?
    var viewModel: CreateBookingVM!
    var onCreated: ((CreateBookingModel?, PatientBookingModel?) -> Void)?
    var dataDateTimeSelected: DoctorScheduleDataModel!
    var goToLogin: (() -> Void)?
    var goToAddFamilyMember: (() -> Void)?
    private let idDetailAppoinmentRelay = BehaviorRelay<String?>(value: nil)
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var model: CreateBookingModel? = nil

    @IBOutlet weak var viewDoctorData: UIView!
    @IBOutlet weak var changeDoctorButton: UIButton!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var imageIconMika: UIImageView!
    @IBOutlet weak var labelMikaHospital: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpecialist: UILabel!
    @IBOutlet weak var buttonChangeDoctor: UIButton!
    @IBOutlet weak var labelSchedulSelected: UILabel!
    @IBOutlet weak var labelTimeScheduleSelected: UILabel!
    
    @IBOutlet weak var viewContainerCost: UIView!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelCostNominal: UILabel!
    
    @IBOutlet weak var labelSelectMediaConsultation: UILabel!
    
    @IBOutlet weak var buttonSelectVideo: DLRadioButton!
    @IBOutlet weak var phoneButtonSelect: DLRadioButton!
    
    @IBOutlet weak var containerButtonBooking: UIView!
    @IBOutlet weak var buttonBooking: UIButton!
    
    @IBOutlet weak var containerPatientData: UIView!
    @IBOutlet weak var nameFormView: FormRow!
    @IBOutlet weak var ageFormView: FormRow!
    @IBOutlet weak var birthdateFormView: FormRow!
    @IBOutlet weak var genderFormView: FormRow!
    @IBOutlet weak var phoneFormView: FormRow!
    @IBOutlet weak var emailFormView: FormRow!
    @IBOutlet weak var stepperCollection: UICollectionView!
    @IBOutlet weak var buttonChangePatient: UIButton!
    
    @IBOutlet weak var flatRateLabel: UILabel!
    var dataDoctor: DetailDoctorModel!
    var patientData: PatientBookingModel!{
        didSet{
            if self.viewIfLoaded?.window != nil {
                updateData()
            }
        }
    }

    private let disposeBag = DisposeBag()
    var id : String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        setDetail()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModel()
        self.registerCollectionView()
        self.viewDidLoadRelay.accept(())
    }
    
    func setupNavigation() {
        self.setTextNavigation(title: "Buat Telekonsultasi", navigator: .back)
    }

    func bindViewModel() {
        setDetail()
    }
    
    private func setDetail(){
        buttonSelectVideo.isSelected = true
        setupActiveButton(button: buttonBooking)
        updateData()
    }
    
    func updateData(){
        let mainProfileData = Preference.structData(UserHomeData.self, forKey: .User)
        let updatedData = CreateBookingModel(
            id: self.dataDoctor.doctorId ?? nil,
            nameDoctor: self.dataDoctor.name,
            idDoctor: self.dataDoctor.doctorId,
            photoDoctor: self.dataDoctor.photo,
            iconHospital: self.dataDoctor.iconHospital,
            nameHospital: self.dataDoctor.nameHospital,
            idHospital: self.dataDoctor.idHospital,
            dateSchedule: self.dataDateTimeSelected.date,
            timeSchedule: "\(self.dataDateTimeSelected.startTime) - \(self.dataDateTimeSelected.endTime)",
            price: self.dataDoctor.price ?? 0,
            priceFormatted: self.dataDoctor.priceFormatted ?? "Rp. 0",
            namePatient: patientData.namePatient,
            agePatient: "\(patientData.agePatient ?? "")",
            dateOfBirthPatient : patientData.dateOfBirthPatient,
            genderPatient: patientData.genderPatient == "MALE" ? "Laki-laki" : "Perempuan",
            phonePatient: patientData.phone != nil ? patientData.phone : mainProfileData?.phone,
            emailPatient: patientData.email != nil ? patientData.email : mainProfileData?.email,
            specializationDoctor: self.dataDoctor.specialization,
            timeStart: self.dataDateTimeSelected.startTime,
            timeEnd: self.dataDateTimeSelected.endTime,
            timeCode: self.dataDateTimeSelected.code,
            promoPriceFormatted: self.dataDoctor.promoPriceFormatted,
            promoPriceRaw: self.dataDoctor.promoPriceRaw
        )
        
        self.model = updatedData
        setForm(model)
    }
    
    func setDummyData(){
        self.containerPatientData.layer.cornerRadius = 5
        self.containerPatientData.layer.masksToBounds = true
        self.nameFormView.clipsToBounds = true
    }
    
    private func setForm(_ model: CreateBookingModel?) {
        guard let model = model else { return }
        
        if let urlPhotoDoctor = URL(string: model.photoDoctor ?? "-") {
            self.imageDoctor.kf.setImage(with: urlPhotoDoctor)
        }
        if let urlPhotoHospital = URL(string: model.iconHospital ?? "-") {
            self.imageIconMika.kf.setImage(with: urlPhotoHospital)
        }
        self.labelMikaHospital.text = model.nameHospital
        self.labelDoctorName.text = model.nameDoctor
        self.labelDoctorSpecialist.text = model.specializationDoctor
        self.labelSchedulSelected.text = model.dateSchedule?.dateIndonesiaStandard()
        self.labelTimeScheduleSelected.text = model.timeSchedule
        self.labelCostNominal.text = model.priceFormatted
        
        self.nameFormView.title.text = "Nama"
        self.nameFormView.value.text = model.namePatient
        self.ageFormView.title.text = "Umur"
        self.ageFormView.value.text = model.agePatient
        self.birthdateFormView.title.text = "Tanggal Lahir"
        self.birthdateFormView.value.text = model.dateOfBirthPatient
        self.genderFormView.title.text = "Jenis Kelamin"
        self.genderFormView.value.text = model.genderPatient
        self.phoneFormView.title.text = "No. Telepon"
        self.phoneFormView.value.text = model.phonePatient
        self.emailFormView.title.text = "Email"
        self.emailFormView.value.text = model.emailPatient
        
        if (model.price == 0) && (model.promoPriceRaw == 0){
            labelCostNominal.text = model.priceFormatted
            flatRateLabel.isHidden = true
        }else{
            if model.promoPriceRaw == 0 {
                labelCostNominal.text = model.priceFormatted
                flatRateLabel.isHidden = true
            }else if (model.promoPriceRaw ?? 0) > 0{
                let attrString = NSAttributedString(string: model.priceFormatted ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                labelCostNominal.attributedText = attrString
                flatRateLabel.isHidden = false
                flatRateLabel.text = model.promoPriceFormatted
            }
            
        }
    }
    
    private func setupUI() {
        self.setupDeactiveButton(button: buttonBooking)
    }
    
    private func registerCollectionView(){
        let cellNib = UINib(nibName: "StepBookingCollectionViewCell", bundle: nil)
        self.stepperCollection.register(cellNib, forCellWithReuseIdentifier: "stepBookingCell")
        
        let flowDayLayout = UICollectionViewFlowLayout()
        flowDayLayout.minimumLineSpacing = 4.0
        flowDayLayout.itemSize = CGSize(width: 220, height: 30)
        flowDayLayout.scrollDirection = .horizontal
        self.stepperCollection.collectionViewLayout = flowDayLayout
        
        self.stepperCollection.delegate = self
        self.stepperCollection.dataSource = self
    }
    
    @IBAction func changePatient(_ sender: Any) {
        self.goToAddFamilyMember?()
    }
    
    @objc @IBAction private func setupMediaSelected(radioButton : DLRadioButton){
        if !self.buttonSelectVideo.isSelected && !self.phoneButtonSelect.isSelected {
            self.setupDeactiveButton(button: buttonBooking)
        } else {
            self.setupActiveButton(button: buttonBooking)
        }
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        self.changeDoctorTapped?()
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBookingTapped(_ sender: Any) {
        if !self.buttonSelectVideo.isSelected && !self.phoneButtonSelect.isSelected {
            
        } else if self.phoneButtonSelect.isSelected {
            self.showToast(message: "Comming Soon")
        } else if self.buttonSelectVideo.isSelected {
            self.onCreated?(model, patientData)
        } else {
            
        }
    }
}

extension CreateBookingVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "stepBookingCell", for: indexPath) as! StepBookingCollectionViewCell
//        if indexPath.row == 0{
//            cell.labelStepNumber.text = "\(indexPath.row + 1)"
//            cell.labelStepTitle.text = "Pilih Dokter"
//        }
        if indexPath.row == 0{
            cell.labelStepNumber.text = "\(2)"
            cell.labelStepTitle.text = "Buat Telekonsultasi"
            cell.labelStepTitle.textColor = .alteaBlueMain
            cell.labelStepTitle.font = UIFont.boldSystemFont(ofSize: 14)
            cell.viewLine.layer.backgroundColor = UIColor.alteaBlueMain.cgColor
        }
        if indexPath.row == 1{
            cell.labelStepNumber.text = "\(3)"
            cell.labelStepTitle.text = "Konfirmasi"
            if #available(iOS 13.0, *) {
                cell.containerView.backgroundColor = UIColor.systemGray3
            } else {
                // Fallback on earlier versions
                cell.containerView.backgroundColor = .alteaDark3
            }
        }
        if indexPath.row == 2{
            cell.labelStepNumber.text = "\(4)"
            cell.labelStepTitle.text = "Bayar"
            if #available(iOS 13.0, *) {
                cell.containerView.backgroundColor = UIColor.systemGray3
            } else {
                // Fallback on earlier versions
                cell.containerView.backgroundColor = .alteaDark3
            }
        }
        return cell
    }
}
