//
//  TabbarView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit

protocol TabbarView: BaseView {
    var onViewDidLoad: ((UINavigationController) -> Void)? { get set }
    var onTheFirstSelected: ((UINavigationController) -> Void)? { get set }
    var onTheSecondSelected: ((UINavigationController) -> Void)? { get set }
    var onTheThirdSelected: ((UINavigationController, Int?) -> Void)? { get set }
    var onTheFourthSelected: ((UINavigationController) -> Void)? { get set }
    var goToByIndexTab: Int? { get set }
    var onIndex3 : ((UINavigationController) -> Void)? { get set }
    var navigateTabInMyConsultation: Int? { get set }
}
