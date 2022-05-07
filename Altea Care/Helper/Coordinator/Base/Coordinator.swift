//
//  Coordinator.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol Coordinator: class {
    func start()
    func start(option with: DeepLinkOption?)
    func start(auth with: AuthEntry)
    func start(with option: DeepLinkOption?, indexTab with : SelectedTabEntry?)
    func start(consultation with: ConsultationModeEntry)
    func start(booking with: BookingModeEntry)
    func start(payment with: PaymentModeEntry)
    func start(family with: FamilyModeEntry)
    func startWithNotif(with option: DeepLinkOption?)
}

enum ConsultationModeEntry {
    case listConsultation(Int?)
    case initialScreening(Int, String?, Bool)
    case cancelledBooking(Int)
    case detailConsultation(Int,ConsultationStatus)
    case reconsultation(Int, String?, Bool)
    case cancelledList
    case doneList
}

enum BookingModeEntry {
    case listDoctorSpecialization(idSpecialist: String, nameSpecialist: String, isSearch: Bool, inputSearch: String, isRoot: Bool)
    case listSpecialization
    case detailDoctor(String, Bool)
    case searchAutocomplete
}

enum SelectedTabEntry{
    case tabIndex(Int)
}

enum AuthEntry{
    case login(photoDoctor: String?, doctorName: String?)
    case register
    case forgotPassword
    case callCenter
}

enum FamilyModeEntry {
    case readFamily
    case listFamily
    case setPassword
    case addMember
    case listAddress
}

enum AddressModeEntry {
    case addFamily
    case editFamily
    case editAddress
    case editProfile
}

enum PaymentModeEntry{
    case waitingForPayment(id: Int)
    case paymentReview(id:Int)
    case basic(id: String)
}
