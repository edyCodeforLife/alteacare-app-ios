//
//  DrawerCallBookingVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class DrawerCallBookingVC: UIViewController, DrawerCallBookingView{
    var onOutsideOperatingHour: ((SettingModel) -> Void)?
    var viewModel: DrawerCallBookingVM!
    var dataCreateBooking: CreateBookingModel!
    var goConnect: ((Int, String?, Bool) -> Void)?
    var patientData: PatientBookingModel!
    var setting: SettingModel?
    
    @IBOutlet weak var imageIconDoctor: UIImageView!
    @IBOutlet weak var labelFirstInstruction: UILabel!
    @IBOutlet weak var labelUserRemind: UILabel!
    @IBOutlet weak var labelMedicalFree: UILabel!
    @IBOutlet weak var buttonConnect: UIButton!
    
    
    private let disposeBag = DisposeBag()
    private let createBookingRelay = BehaviorRelay<CreateConsultationBody?>(value: nil)
    
    private let idRelay = BehaviorRelay<String?>(value:nil)
    
    var flagButton : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActiveButton(button: buttonConnect)
        self.setupNavigation()
        self.setupLabel()
        
    }
    
    func bindViewModel() {
        let dataSchedules = CreateConsultationSchedule(code: self.dataCreateBooking.timeCode, date: self.dataCreateBooking.dateSchedule, startTime: self.dataCreateBooking.timeStart, endTime: self.dataCreateBooking.timeEnd)
        
        //MARK: - Add Patient Id
        let bodyCreateBookingData = CreateConsultationBody(doctorId: self.dataCreateBooking.id ?? "-", symptomNote: "-", patientId: self.patientData.id, consultationMethod: "VIDEO_CALL", nextStep: "ASK_MA", refferenceAppointmentId: "", schedules: [dataSchedules])
        
        createBookingRelay.accept(bodyCreateBookingData)
        let input = DrawerCallBookingVM.Input(body: createBookingRelay.asObservable())
        let ouput = viewModel.transform(input)
        ouput.state.drive(self.rx.state).disposed(by: self.disposeBag)
        ouput.state.drive { (_) in
        }.disposed(by: self.disposeBag)
        ouput.setting.drive{(model) in
            self.setting = model
        }.disposed(by: disposeBag)
        ouput.createBookingData.drive { (model) in
            if model?.inOperationalHour ?? false {
                self.goConnect?(model?.appointmentId ?? 0, model?.orderCode, true)
            } else {
                self.onOutsideOperatingHour?(
                    self.setting ?? SettingModel(operationalHourStart: "", operationalHourEnd: "")
                )
            }
            
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if flagButton == true{
            bindViewModel()
            buttonConnect.isEnabled = false
        }
    }
    
    private func setupNavigation(){
        
        if #available(iOS 13.0, *) {
            self.setTextNavigation(title: "", navigator: .none)
        } else {
            self.setTextNavigation(title: "", navigator: .close)
        }
        self.navigationController?.navigationBar.isHidden = false
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupLabel(){
        let text = "Anda akan terhubung dengan Medical Advisor untuk memvalidasi identitas dan mengonfirmasi rencana telekonsultasi. Diperlukan KTP dan dokumen penunjang medis (laboratorium, radiologi, dll) bila ada yang berhubungan  dengan keluhan Anda"
        
        labelFirstInstruction.text = text
        
        self.labelFirstInstruction.textColor = UIColor.black
        
        let boldTextLabelInstruction = NSMutableAttributedString(string: text)
        let rangeKTP = (text as NSString).range(of: "KTP")
        let rangeDocument = (text as NSString).range(of: "dokumen penunjang medis (laboratorium, radiologi, dll)")
        
        boldTextLabelInstruction.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: rangeKTP)
        boldTextLabelInstruction.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: rangeDocument)
        
        labelFirstInstruction.attributedText = boldTextLabelInstruction
    }
}
