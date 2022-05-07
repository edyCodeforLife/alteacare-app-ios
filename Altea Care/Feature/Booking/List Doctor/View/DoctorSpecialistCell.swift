//
//  DoctorSpecialistCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 22/03/21.
//

import UIKit

class DoctorSpecialistCell: UITableViewCell {
  
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var imageMika: UIImageView!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelNameHospital: UILabel!
    @IBOutlet weak var labelNameDoctor: UILabel!
    @IBOutlet weak var labelLanguangeList: UILabel!
    @IBOutlet weak var labelPriceBooking: UILabel!
    @IBOutlet weak var labelSpecialistDoctor: UILabel!
    @IBOutlet weak var labelDoctorDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    func setupDoctorListSpecialist(model : ListDoctorModel){
//        self.labelExperience.text = "\(model.experienceYear) Th Pengalaman"
//        self.labelNameHospital.text = "\(model.hospitalName)"
//        self.labelNameDoctor.text = model.doctorName
//        self.labelLanguangeList.text = model.languangeCompetence
//        self.labelPriceBooking.text = "Rp.\(model.priceConsultation)"
//        self.labelSpecialistDoctor.text = model.doctorSpecialist
//        self.labelDoctorDescription.text = model.doctorDescription
//    }
}
