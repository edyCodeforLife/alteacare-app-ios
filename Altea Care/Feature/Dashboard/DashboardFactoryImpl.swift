//
//  DashboardFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: DashboardFactory {
    func makeWebView() -> WebView {
        let vc = WebViewVC()
        return vc
    }
    
    func makeHomeView() -> HomeView {
        let vc = HomeVC()
        vc.viewModel = makeHomeVM()
        return vc
    }
    
    func makeListDoctorView() -> ListDoctorView {
        let vc =  ListDoctorVC()
        vc.viewModel = makeListDoctorVM()
        return vc
    }
    
    func makeSwitchAccountView() -> SwitchAccountView {
        let vc = SwitchAccountVC()
        vc.viewModel = makeSwitchAccountVM()
        return vc
    }
    
    func makeForceUpdateView() -> ForceUpdateView {
        let vc = ForceUpdateVC()
        vc.viewModel = makeForceUpdateVM()
        return vc
    }
    
    func makeOutsideOperatingHourViewFromDashboard(setting: SettingModel) -> OutsideOperatingHourView {
        let vc = OutsideOperatingHourViewController()
        vc.setting = setting
        return vc
    }
}
