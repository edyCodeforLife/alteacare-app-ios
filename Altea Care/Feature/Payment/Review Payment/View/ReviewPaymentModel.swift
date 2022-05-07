//
//  ReviewPaymentModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

//struct ReviewPaymentModel {
//    let nameHospital : String?
//    let iconHospital : String?
//    let photoDoctor : String?
//    let nameDoctor : String?
//    let nameSpecialist : String?
//    let date : String?
//    let hour : String?
//    let paymentTotal : String?
//    let paymentTelekonsultasi : String?
//    let paymentService : String?
//}
struct ReviewPaymentModel {
    let orderId : String?
    let orderCode: String?
    let doctor: DoctorCardModel?
    let fees : [InquiryPaymentFeeModel]
    let total : Double?
    
}
