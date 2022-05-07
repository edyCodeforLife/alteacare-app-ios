//
//  BookingCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol BookingCoordinatorOutput {
    var onEndBooking: (() -> Void)? { get set }
    ///For change user
    var onAuthFlow : (() -> Void)? { get set }
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)? { get set }
    var goToDashboard: (() -> Void)? { get set }
    var onEndConsultation : (() ->Void)? { get set }
    var gotoMyConsultation: (()-> Void)? { get set }
}
