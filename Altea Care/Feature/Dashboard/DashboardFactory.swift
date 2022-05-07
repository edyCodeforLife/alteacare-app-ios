//
//  DashboardFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol DashboardFactory {
    func makeHomeView() -> HomeView
    func makeListDoctorView() -> ListDoctorView
    func makeWebView() -> WebView
    func makeSwitchAccountView() -> SwitchAccountView
    func makeForceUpdateView() -> ForceUpdateView
    func makeOutsideOperatingHourViewFromDashboard(setting: SettingModel) -> OutsideOperatingHourView
    func makeReviewPayment() -> ReviewPaymentView
    func makeWebViewPayment() -> AlteaPaymentVAView
    func makeCloseConfirmationView() -> ClosePaymentConfirmationView
}
