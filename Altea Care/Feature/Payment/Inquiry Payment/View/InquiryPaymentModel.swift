//
//  InquiryPaymentModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import UIKit
struct InquiryPaymentModel {
    let id : String?
    let code: String?
    let doctor: DoctorCardModel?
    let fees : [InquiryPaymentFeeModel]
    let total : Double?
    
}
struct InquiryPaymentFeeModel {
    let name: String?
    let price: String?
    
}
