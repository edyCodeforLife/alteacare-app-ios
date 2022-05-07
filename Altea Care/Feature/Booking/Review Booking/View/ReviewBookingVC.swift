//
//  ReviewBookingVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices
import PanModal

class ReviewBookingVC: UIViewController, ReviewBookingView {
    var onReviewed: ((CreateBookingModel?, PatientBookingModel?) -> Void)?
    var dataCreateBooking: CreateBookingModel?
    var changeDataPatientTapped: ((String, String) -> Void)?
    
    @IBOutlet weak var containerDoctor: UIView!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var iconMikaHospital: UIImageView!
    @IBOutlet weak var labelHospitalName: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelSpecialist: UILabel!
    
    @IBOutlet weak var containerSchedule: UIView!
    @IBOutlet weak var labelDateSelected: UILabel!
    @IBOutlet weak var iconDate: UIImageView!
    
    @IBOutlet weak var containerTimeHour: UIView!
    @IBOutlet weak var labelTimeHourSelected: UILabel!
    @IBOutlet weak var iconTimeClock: UIImageView!
    
    @IBOutlet weak var containerCost: UIView!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelCostNominal: UILabel!
    
    @IBOutlet weak var flatrateLabel: UILabel!
    @IBOutlet weak var containerDataPatient: UIView!
    @IBOutlet weak var labelDataPatient: UILabel!
    
    @IBOutlet weak var containerFormView: UIView!
    @IBOutlet weak var formUsername: FormRow!
    @IBOutlet weak var formAge: FormRow!
    @IBOutlet weak var formBirthdate: FormRow!
    @IBOutlet weak var formGender: FormRow!
    @IBOutlet weak var formPhonenumber: FormRow!
    @IBOutlet weak var formEmail: FormRow!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var containerButton: UIView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonChangeData: UIButton!
    
    @IBOutlet weak var stepperCollection: UICollectionView!
    
    var gradientLayer = CAGradientLayer()
    
    var viewModel: ReviewBookingVM!
    var goToAddFamilyMember: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    private let createBookingRelay = BehaviorRelay<CreateConsultationBody?>(value: nil)
    private let idRelay = BehaviorRelay<String?>(value:nil)
  
    private var model: PatientDataModel? = nil
    private var urlPhoto = ""
    private var nameDoctor = ""
    
    var id: String!
    var patientData: PatientBookingModel?{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let _ = self.patientData else {return}
                self.updatePatientData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.bindViewModel()
        
        self.setupActiveButton(button: buttonNext)
        self.setupSecondaryButton(button: buttonChangeData)
        self.idRelay.accept(self.id)
        self.registerCollectionView()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.topColor.cgColor, UIColor.bottomColor.cgColor]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        setForm()
    }
    
    func setupNavigation() {
        self.setTextNavigation(title: "Rincian Telekonsultasi", navigator: .back)
    }

    func bindViewModel() {
        
        let input = ReviewBookingVM.Input(fetch: idRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
        
        }.disposed(by: self.disposeBag)
        output.patientData.drive { (model) in
//            self.setupDataPatient(model)
        }.disposed(by: self.disposeBag)
        
    }
        
    func setForm() {
        if let urlPhotoDoctor = URL(string: dataCreateBooking!.photoDoctor ?? "") {
            self.imageDoctor.kf.setImage(with: urlPhotoDoctor)
            self.urlPhoto = dataCreateBooking?.photoDoctor ?? ""
        }
        if let urlPhotoHospital = URL(string: dataCreateBooking?.iconHospital ?? "") {
            self.iconMikaHospital.kf.setImage(with: urlPhotoHospital)
        }
        
        self.nameDoctor = dataCreateBooking?.nameDoctor ?? ""
        self.labelHospitalName.text = dataCreateBooking?.nameHospital
        self.labelDoctorName.text = dataCreateBooking?.nameDoctor
        self.labelSpecialist.text = dataCreateBooking?.specializationDoctor
        self.labelDateSelected.text = dataCreateBooking?.dateSchedule?.dateIndonesiaStandard()
        self.labelTimeHourSelected.text = dataCreateBooking?.timeSchedule
        self.labelCostNominal.text = dataCreateBooking?.priceFormatted
        
        self.formUsername.title.text = "Nama"
        self.formUsername.value.text = dataCreateBooking?.namePatient
        self.formAge.title.text = "Umur"
        self.formAge.value.text = dataCreateBooking?.agePatient
        self.formBirthdate.title.text = "Tanggal Lahir"
        self.formBirthdate.value.text = dataCreateBooking?.dateOfBirthPatient
        self.formGender.title.text = "Jenis Kelamin"
        self.formGender.value.text = dataCreateBooking?.genderPatient == "MALE" ? "Laki-laki" : "Perempuan"
        self.formPhonenumber.title.text = "No. Telepon"
        self.formPhonenumber.value.text = dataCreateBooking?.phonePatient
        self.formEmail.title.text = "Email"
        self.formEmail.value.text = dataCreateBooking?.emailPatient
        
        if (dataCreateBooking?.price == 0) && (dataCreateBooking?.promoPriceRaw == 0){
            labelCostNominal.text = dataCreateBooking?.priceFormatted
            flatrateLabel.isHidden = true
        }else{
            if dataCreateBooking?.promoPriceRaw == 0 {
                labelCostNominal.text = dataCreateBooking?.priceFormatted
                flatrateLabel.isHidden = true
            }else if (dataCreateBooking?.promoPriceRaw ?? 0) > 0{
                let attrString = NSAttributedString(string: dataCreateBooking?.priceFormatted ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                labelCostNominal.attributedText = attrString
                flatrateLabel.isHidden = false
                flatrateLabel.text = dataCreateBooking?.promoPriceFormatted
            }
            
        }
    }
    
    func updatePatientData(){
        let mainProfileData = Preference.structData(UserHomeData.self, forKey: .User)
        guard let patientData = patientData else {return}
        dataCreateBooking?.namePatient = patientData.namePatient
        dataCreateBooking?.agePatient = patientData.agePatient
        dataCreateBooking?.dateOfBirthPatient = patientData.dateOfBirthPatient
        dataCreateBooking?.genderPatient = patientData.genderPatient
        dataCreateBooking?.emailPatient = patientData.email != nil ? patientData.email : mainProfileData?.email
        dataCreateBooking?.phonePatient = patientData.phone != nil ? patientData.phone : mainProfileData?.phone
        setForm()
    }
    
    func registerCollectionView(){
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
    @IBAction func actionChangePatient(_ sender: Any) {
        self.changeDataPatientTapped?(self.urlPhoto, self.nameDoctor)

    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        self.setupTracker()
        self.onReviewed?(dataCreateBooking, patientData)
    }
}

extension ReviewBookingVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "stepBookingCell", for: indexPath) as! StepBookingCollectionViewCell
//        if indexPath.row == 0{
//            cell.labelStepNumber.text = "\(indexPath.row + 1)"
//            cell.labelStepTitle.text = "Pilih Dokter"
//        }
//        if indexPath.row == 1{
//            cell.labelStepNumber.text = "\(indexPath.row + 1)"
//            cell.labelStepTitle.text = "Buat Telekonsultasi"
//        }
        if indexPath.row == 0{
            cell.labelStepNumber.text = "\(3)"
            cell.labelStepTitle.text = "Konfirmasi"
            cell.labelStepTitle.textColor = .alteaBlueMain
            cell.labelStepTitle.font = UIFont.boldSystemFont(ofSize: 14)
            cell.viewLine.layer.backgroundColor = UIColor.alteaBlueMain.cgColor
        }
        if indexPath.row == 1{
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

//MARK: - Setup Tracker
extension ReviewBookingVC {
    
    func setupTracker() {
        self.track(.bookSchedule(AnalyticsBookSchedule(hospitalId: dataCreateBooking?.idHospital, hospitalName: dataCreateBooking?.nameHospital, hospitalArea: nil, bookingDay: nil, bookingDate: dataCreateBooking?.dateSchedule, bookingHours: dataCreateBooking?.timeStart, doctorId: dataCreateBooking?.idDoctor, doctorName: dataCreateBooking?.nameDoctor, doctorSpeciality: dataCreateBooking?.specializationDoctor)))
    }
}
