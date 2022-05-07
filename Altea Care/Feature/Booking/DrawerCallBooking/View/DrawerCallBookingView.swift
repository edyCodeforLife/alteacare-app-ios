//
//  DrawerCallBookingView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import Foundation

protocol DrawerCallBookingView : BaseView {
    var viewModel : DrawerCallBookingVM! { get set }
    var dataCreateBooking : CreateBookingModel! { get set }
    var patientData : PatientBookingModel! { get set}
    var goConnect : ((_ id : Int, _ orderCode: String?, _ callMA: Bool) -> Void)? { get set}
    var onOutsideOperatingHour: ((SettingModel)->Void)? { get set }
}
