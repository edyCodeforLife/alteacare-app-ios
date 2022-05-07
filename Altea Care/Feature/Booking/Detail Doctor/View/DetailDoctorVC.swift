//
//  DetailDoctorVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal
import Lottie
import PanModal

class DetailDoctorVC: UIViewController, DetailDoctorView, PanModalPresentable {
    var isFormListDoctor: Bool!
    var panScrollable: UIScrollView?
    var onDatetimeTapped: ((DoctorScheduleDataModel, DetailDoctorModel) -> Void)?
    var onButtonSeeAllSchedule: (() -> Void)?
    var onButtonNextTapped: (() -> Void)?
    var viewModel: DetailDoctorVM!
    var idDoctor: String!
    var selectedDayName: DayName?
    var dataDateTimeSelected: DoctorScheduleDataModel!
    var goToAddFamilyMember: (() -> Void)?
    var goToLogin: ((String, String) -> Void)?
    
    @IBOutlet weak var avLoadingSchedule: AnimationView!
    @IBOutlet weak var imageViewDoctor: UIImageView!
    @IBOutlet weak var stackContainerDoctor: UIStackView!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelSpecialist: UILabel!
    @IBOutlet weak var imageMika: UIImageView!
    @IBOutlet weak var labelHospitalName: UILabel!
    @IBOutlet weak var labelLanguageSkill: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelScheduleList: UILabel!
    @IBOutlet weak var labelScheduleInfo: UILabel!
    @IBOutlet weak var viewSelectDate: UIView!
    @IBOutlet weak var labelSetDate: UILabel!
    @IBOutlet weak var imageIconDate: UIImageView!
    @IBOutlet weak var collectionViewDaySelect: UICollectionView!
    @IBOutlet weak var collectionViewTimeSchedule: UICollectionView!
    @IBOutlet weak var labelDoctorProfile: UILabel!
    @IBOutlet weak var labelDoctorDescription: UILabel!
    @IBOutlet weak var labelTitleSpecialist: UILabel!
    @IBOutlet weak var labelDoctorAbility: UILabel!
    @IBOutlet weak var labelTitleCancelRefund: UILabel!
    @IBOutlet weak var labelRefundExplanation: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var vLoading: UIView!
    
    ///Stack View
    @IBOutlet weak var stackDoctor: UIStackView!
    @IBOutlet weak var stackSelectSchedule: UIStackView!
    @IBOutlet weak var stackSelectDay: UIStackView!
    @IBOutlet weak var stackSelectTime: UIStackView!
    @IBOutlet weak var stackTermCondition: UIStackView!
    @IBOutlet weak var stackDoctorProfile: UIStackView!
    
    @IBOutlet weak var containerEmptySchedule: UIView!
    @IBOutlet weak var iconEmptySchedule: UIImageView!
    @IBOutlet weak var labelEmptySchedule: UILabel!
    
    @IBOutlet weak var collectionViewVerticalDaysForward: UICollectionView!
    
    private var tempDateSelected : Date = Date()
    private var tempTimeScheduleSelected : String = ""
    var datePicker = UIDatePicker()
    var selectedDates = [Date]()
    var isCustomSchedule = false
    
    private let disposeBag = DisposeBag()
    private let detailsDoctorData = BehaviorRelay<String?>(value: "")
    private let scheduleDoctor = BehaviorRelay<DoctorScheduleBody>(value: DoctorScheduleBody(idDoctor: "", date: ""))
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var isTimeSelected = false
    var modelDataDoctor : DetailDoctorModel? = nil
    {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }
    var scheduleData : DoctorScheduleModel? = nil
    
    private var model = [DayName](){
        didSet{
            self.collectionViewDaySelect.reloadData()
            if let dayName = selectedDayName{
                if let selectedIndex = model.firstIndex(where: {$0.day == dayName.day}){
                    //                    self.collectionViewDaySelect.selectItem(at: IndexPath(row:0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                    DispatchQueue.main.async {
                        
                        self.collectionViewDaySelect.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .right)
                    }
                    
                    print("selctedIndex \(selectedIndex)")
                }
            }
            
        }
    }
    
    //MARK: - Set Time schedule
    private var modelTime = [DoctorScheduleDataModel](){
        didSet{
            self.collectionViewTimeSchedule.reloadData()
        }
    }
    
    private lazy var scheduleDoctorList : ScheduleTimePickerVC = {
        let vc = ScheduleTimePickerVC()
        vc.delegate = self
        return vc
    }()
    
    private lazy var dateTime : DatePickerVC = {
        let vc = DatePickerVC()
        vc.delegate = self
        return vc
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.bindViewModel()
        self.setupButtonDeselect()
        self.setupLabelExperience()
        self.setupDummyDay()
        self.registerCollectionViewCell()
        self.setupLabelDatePicker()
        if let dayName = selectedDayName{
            self.scheduleDoctor.accept(DoctorScheduleBody(idDoctor: self.idDoctor, date: dayName.date))
        }else{
            self.scheduleDoctor.accept(DoctorScheduleBody(idDoctor: self.idDoctor, date: Date().toStringDefault()))
        }
        self.detailsDoctorData.accept(idDoctor)
        self.viewDidLoadRelay.accept(())
        self.setupLoadingLottie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigation()
    }
    
    func bindViewModel() {
        let input = DetailDoctorVM.Input(doctorDetailsData: self.detailsDoctorData.asObservable(), scheduleData: self.scheduleDoctor.asObservable(), viewDidLoadRelay: self.viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.doctorDataDetails.drive { (model) in
            self.modelDataDoctor = model
            self.setupDataDoctor(data: self.modelDataDoctor)
            self.setupTracker()
        }.disposed(by: self.disposeBag)
        output.doctorDetailsSchedule.drive { (list) in
            self.scheduleData = list
            self.modelTime = list?.data ?? []
            self.vLoading.isHidden = true
            self.containerEmptySchedule.isHidden = true
            self.setupInitiateView()
            if self.isCustomSchedule {
                self.showSchedule(time: self.modelTime)
            }
        }.disposed(by: self.disposeBag)
        output.termRefundCancel.drive { (modelTerm) in
            self.setupRefundTerm(data: modelTerm)
        }.disposed(by: self.disposeBag)
        output.errorSchedule.skip(1).drive { (result) in
            self.vLoading.isHidden = true
            if self.isCustomSchedule {
                self.showSchedule(time: [])
            } else {
                self.containerEmptySchedule.isHidden = false
                self.collectionViewTimeSchedule.isHidden = true
                self.collectionViewVerticalDaysForward.isHidden = true
            }
        }.disposed(by: self.disposeBag)
    }
    
    func setupLoadingLottie() {
        self.avLoadingSchedule.backgroundColor = .clear
        self.avLoadingSchedule.contentMode = .scaleAspectFit
        self.avLoadingSchedule.loopMode = .loop
        self.avLoadingSchedule.isUserInteractionEnabled = false
        self.avLoadingSchedule.play()
    }
    
    //MARK: - Setup data doctor
    func setupDataDoctor(data: DetailDoctorModel?){
        if (data?.photo!.isEmpty)! || data?.photo! == "-" {
            self.imageViewDoctor.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: data?.photo ?? ""){
                imageViewDoctor.kf.setImage(with: urlPhotoPerson)
            }
        }
        
        if let urlPhotoHospital = URL(string: data?.iconHospital ?? "" ){
            imageMika.kf.setImage(with: urlPhotoHospital)
        }
        
        labelSpecialist.text = data?.specialization
        labelExperience.text = data?.experience
        labelDoctorName.text = data?.name
        labelLanguageSkill.text = data?.language
        labelHospitalName.text = data?.nameHospital
        labelDoctorDescription.attributedText = data?.about?.htmlAttributedString()
        labelDoctorDescription.font = UIFont(name: "Inter-Regular", size: 12)
    }
    
    func setupRefundTerm(data : TermRefundCancelModel?){
        self.labelRefundExplanation.attributedText = (data?.textTermRefund)?.htmlAttributedString()
        self.labelRefundExplanation.font = UIFont(name: "Inter-Regular", size: 12)
    }
    
    //MARK: - label set date tapped
    func setupLabelDatePicker(){
        let text = "Atur Tanggal"
        
        self.labelSetDate.text = text
        self.labelSetDate.isUserInteractionEnabled = true
        
        self.labelSetDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(taplabelDate)))
    }
    
    //MARK: - Configure pan model when Atur Tanggal tapping
    @objc func taplabelDate(){
        if isCustomSchedule {
            self.isCustomSchedule = false
            self.tempDateSelected = Date()
            self.setupInitiateView()
            self.scheduleDoctor.accept(DoctorScheduleBody(idDoctor: self.idDoctor, date: self.tempDateSelected.toStringDefault()))
        } else {
            self.presentPanModal(self.dateTime)
        }
    }
    
    func setupNavigation() {
        if self.isFormListDoctor {
            self.setTextNavigation(title: "Detail Dokter", navigator: .back)
        } else {
            self.setTextNavigation(title: "Detail Dokter", navigator: .close)
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupButtonDeselect(){
        buttonSubmit.layer.cornerRadius = 8
        buttonSubmit.layer.backgroundColor = UIColor.alteaDark2.cgColor
        buttonSubmit.setTitleColor(.white, for: .normal)
    }
    
    func setupButtonSelected(){
        buttonSubmit.layer.cornerRadius = 8
        buttonSubmit.layer.backgroundColor = UIColor.alteaMainColor.cgColor
        buttonSubmit.setTitleColor(.white, for: .normal)
    }
    
    func setupLabelExperience(){
        labelExperience.layer.cornerRadius = 8
        labelExperience.layer.backgroundColor = UIColor.softblue.cgColor
    }
    
    func registerCollectionViewCell(){
        let cellNib = UINib(nibName: "DayCollectionViewCell", bundle: nil)
        self.collectionViewDaySelect.register(cellNib, forCellWithReuseIdentifier: "dayNameCell")
        
        let cellNibTime = UINib(nibName: "TimeScheduleCell", bundle: nil)
        self.collectionViewTimeSchedule.register(cellNibTime, forCellWithReuseIdentifier: "doctorTimeScheduleCell")
        
        let cellNibSevenDays = UINib(nibName: "VerticalDayListCell", bundle: nil)
        self.collectionViewVerticalDaysForward.register(cellNibSevenDays, forCellWithReuseIdentifier: "cellVerticalDaysForward")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        self.collectionViewTimeSchedule.collectionViewLayout = flowLayout
        
        let flowLayoutSevenDays = UICollectionViewFlowLayout()
        flowLayoutSevenDays.minimumInteritemSpacing = 0
        self.collectionViewVerticalDaysForward.collectionViewLayout = flowLayoutSevenDays
        
        let flowDayLayout = UICollectionViewFlowLayout()
        flowDayLayout.minimumLineSpacing = 6.0
        flowDayLayout.scrollDirection = .horizontal
        self.collectionViewDaySelect.collectionViewLayout = flowDayLayout
        
        self.collectionViewVerticalDaysForward.delegate = self
        self.collectionViewVerticalDaysForward.dataSource = self
        
        self.collectionViewDaySelect.delegate = self
        self.collectionViewDaySelect.dataSource = self
        
        self.collectionViewTimeSchedule.delegate = self
        self.collectionViewTimeSchedule.dataSource = self
        
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionViewDaySelect.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
    }
    
    //MARK: - Setup for initial schedule view style
    ///If user have not selected date, so the time scheulde appear based on day selected
    ///But if user have selected date, so the time schedule is hidden and show 7 forward list asc
    
    func setupDummyDay(){
        var days = [DayName]()
        for indexDate in 0...6 {
            let idDay = Date().getIdDayByAdding(count: indexDate, date: Date())
            let day = Date().getDayByAdding(count: indexDate, date: Date())
            let date = Date().getDateByAdding(count: indexDate, date: Date())
            days.append(DayName(id: idDay, day: day, date: date))
        }
        model = days
    }
    
    func arrayOfDates() -> NSArray {
        
        let numberOfDays: Int = 6
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd"
        let startDate = Date()
        let calendar = Calendar.current
        var offset = DateComponents()
        var dates: [Any] = [formatter.string(from: startDate)]
        
        for i in 1..<numberOfDays {
            offset.day = i
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!)
            dates.append(nextDayString)
        }
        return dates as NSArray
    }
    
    //SetupDayName using Calender Kit
    func setupInitiateView(){
        let state = self.tempDateSelected.isSame(Date())
        self.collectionViewVerticalDaysForward.isHidden = state
        self.collectionViewDaySelect.isHidden = !state
        self.collectionViewTimeSchedule.isHidden = !state
        
        if !state {
            self.labelSetDate.text = "Hapus"
            self.labelSetDate.textColor = .alteaRedMain
        } else {
            self.labelSetDate.text = "Atur Tanggal"
            self.labelSetDate.textColor = .alteaMainColor
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let token = Preference.getString(forKey: .AccessTokenKey)
        print("ini token \(String(describing: token))")
        if ((token?.isNotEmpty) != nil){
            if isTimeSelected {
                self.onDatetimeTapped?(self.dataDateTimeSelected, self.modelDataDoctor ?? DetailDoctorModel(doctorId: nil,
                                                                                                            name: nil,
                                                                                                            about: nil,
                                                                                                            overview: nil,
                                                                                                            language: nil,
                                                                                                            photo: nil, sip: nil,
                                                                                                            experience: nil,
                                                                                                            idSpecialization: nil,
                                                                                                            specialization: nil,
                                                                                                            iconHospital: nil,
                                                                                                            nameHospital: nil,
                                                                                                            idHospital: nil,
                                                                                                            price: nil,
                                                                                                            priceFormatted: nil,
                                                                                                            promoPriceFormatted: nil, promoPriceRaw: nil))
            }
        } else {
            self.goToLogin?(self.modelDataDoctor?.photo ?? "", self.modelDataDoctor?.name ?? "")
            print("ini token \(String(describing: token))")
        }
    }
    
}

extension DetailDoctorVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - Configure data at cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTimeSchedule {
            return modelTime.count
        } else if collectionView == self.collectionViewDaySelect {
            return model.count
        } else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewTimeSchedule {
            return CGSize(width: (self.collectionViewTimeSchedule.frame.width-8)/3, height: 28)
        } else if collectionView == self.collectionViewDaySelect {
            return CGSize(width: 70, height: 30)
        } else if collectionView == self.collectionViewVerticalDaysForward {
            return CGSize(width: self.collectionViewVerticalDaysForward.frame.width, height: 30)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewTimeSchedule {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorTimeScheduleCell", for: indexPath) as! TimeScheduleCell
        } else if collectionView == self.collectionViewDaySelect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayNameCell", for: indexPath) as! DayCollectionViewCell
            cell.backView.backgroundColor = UIColor.white
        } else if collectionView ==  self.collectionViewVerticalDaysForward {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellVerticalDaysForward", for: indexPath) as! VerticalDayListCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewTimeSchedule {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorTimeScheduleCell", for: indexPath) as! TimeScheduleCell
            let model =  self.modelTime[indexPath.row]
            
            cell.setupCellTime(model: model)
            if cell.isSelected {
            }
            return cell
        }
        
        if collectionView == self.collectionViewDaySelect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayNameCell", for: indexPath) as! DayCollectionViewCell
            let model =  self.model[indexPath.row]
            
            if cell.isSelected { }
            cell.setupDay(model: model)
            return cell
        }
        
        if collectionView == self.collectionViewVerticalDaysForward {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellVerticalDaysForward", for: indexPath) as! VerticalDayListCell
            cell.labelDateTime.text = self.selectedDates[indexPath.row].getIndonesianFullDateString()
            cell.onSeeAllTapped = { [weak self] in
                guard let self = self else { return }
                let date = self.selectedDates[indexPath.row]
                self.vLoading.isHidden = false
                self.scheduleDoctorList.selectedDate = date
                self.scheduleDoctor.accept(DoctorScheduleBody(idDoctor: self.idDoctor, date: date.toStringDefault()))
            }
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewDaySelect {
            self.scheduleDoctor.accept(DoctorScheduleBody(idDoctor: self.idDoctor, date: self.model[indexPath.row].date))
            self.vLoading.isHidden = false
            self.containerEmptySchedule.isHidden = true
            self.collectionViewTimeSchedule.isHidden = true
            self.collectionViewVerticalDaysForward.isHidden = true
            self.isTimeSelected = false
            self.setupButtonDeselect()
        } else if collectionView == self.collectionViewTimeSchedule {
            self.dataDateTimeSelected = self.modelTime[indexPath.row]
            self.isTimeSelected = true
            self.setupButtonSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewTimeSchedule {
            self.dataDateTimeSelected = self.modelTime[indexPath.row]
            self.isTimeSelected = true
            self.setupButtonDeselect()
        }
    }
}


//MARK: - Delegate Date Picker
extension DetailDoctorVC : DatePickerDelegate{
    func dateSelected(date: Date) {
        self.isCustomSchedule = true
        self.tempDateSelected = date
        self.selectedDates = self.processDate(date: date)
        self.collectionViewVerticalDaysForward.reloadData()
        self.containerEmptySchedule.isHidden = true
        self.setupInitiateView()
    }
    
    func processDate(date: Date) -> [Date] {
        var temp = [Date]()
        var tempDate = date
        for _ in 1...7 {
            temp.append(tempDate)
            tempDate = tempDate.getNextDate()
        }
        return temp
    }
}

extension DetailDoctorVC : ScheduleTimePickerDelegate{
    func showSchedule(time: [DoctorScheduleDataModel]) {
        self.scheduleDoctorList.model = time
        self.presentPanModal(self.scheduleDoctorList)
    }
    
    func timeSelected(time: DoctorScheduleDataModel) {
        self.dataDateTimeSelected = time
        self.isTimeSelected = true
        self.buttonTapped(self.buttonSubmit)
    }
}

//MARK: - Setup Tracker
extension DetailDoctorVC {
    
    func setupTracker() {
        self.track(.viewDoctorProfile(AnalyticsViewDoctorProfile(doctorId: modelDataDoctor?.doctorId, doctorName: modelDataDoctor?.name, specialty: modelDataDoctor?.specialization)))
    }
}
