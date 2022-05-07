//
//  ScheduleTimePickerVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 14/04/21.
//

import UIKit
import PanModal

protocol ScheduleTimePickerDelegate: NSObject {
    func timeSelected(time: DoctorScheduleDataModel)
}

class ScheduleTimePickerVC: UIViewController, PanModalPresentable{
    
    weak var delegate : ScheduleTimePickerDelegate?
    
    var panScrollable: UIScrollView?
    
    var isShortFormEnable = false
    
    var showDragIndicator: Bool{
        return false
    }
    
    var model = [DoctorScheduleDataModel]()
    var selectedTime : DoctorScheduleDataModel?
    var selectedDate : Date?
    
    @IBOutlet weak var line: ACView!
    @IBOutlet weak var labelPilihJadwal: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var collectionViewSchedule: UICollectionView!
    @IBOutlet weak var submitButton: ACButton!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionView()
        self.setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionViewSchedule.reloadData()
        self.labelDate.text = (self.selectedDate ?? Date()).getIndonesianFullDateString()
        self.emptyView.isHidden = self.model.count != 0
    }
    
    func setupButton(){
        self.submitButton.set(type: .disabled, title: "Pilih")
        self.submitButton.isHidden = false
        self.submitButton.onTapped = {
            self.dismiss(animated: true) {
                if let time = self.selectedTime {
                    self.delegate?.timeSelected(time: time)
                }
                self.selectedTime = nil
            }
        }
    }
    
    func registerCollectionView(){
        let cellNib = UINib(nibName: "TimeScheduleCell", bundle: nil)
        self.collectionViewSchedule.register(cellNib, forCellWithReuseIdentifier: "doctorTimeScheduleCell")
        
        self.collectionViewSchedule.delegate = self
        self.collectionViewSchedule.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: ((collectionViewSchedule.frame.width-8)/3), height: 28)
        self.collectionViewSchedule.collectionViewLayout = flowLayout
    }
}

extension ScheduleTimePickerVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorTimeScheduleCell", for: indexPath) as! TimeScheduleCell
        
        let model =  self.model[indexPath.row]
        cell.isSelected = false
        cell.setupCellTime(model: model)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTime = self.model[indexPath.row]
        self.submitButton.set(type: .filled(custom: .alteaMainColor), title: "Pilih")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectedTime = nil
        self.submitButton.set(type: .disabled, title: "Pilih")
    }
    
}
