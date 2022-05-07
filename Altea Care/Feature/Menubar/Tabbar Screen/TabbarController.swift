//
//  TabbarController.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
    var onIndex3: ((UINavigationController) -> Void)?
    
    
    var goToByIndexTab: Int? {
        didSet {
            guard let index = self.goToByIndexTab else { return }
            self.selectedIndex = index
            self.tabBarController(self, didSelect: self)
        }
    }
    
    var navigateTabInMyConsultation: Int? {
        didSet {
            if self.navigateTabInMyConsultation != nil {
                self.selectedIndex = 2
                self.tabBarController(self, didSelect: self)
            }
        }
    }
    
    var onViewDidLoad: ((UINavigationController) -> Void)?
    var onTheFirstSelected: ((UINavigationController) -> Void)?
    var onTheSecondSelected: ((UINavigationController) -> Void)?
    var onTheThirdSelected: ((UINavigationController, Int?) -> Void)?
    var onTheFourthSelected: ((UINavigationController) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.isTranslucent = true
        if let controller = customizableViewControllers?.first as? UINavigationController {
            onViewDidLoad?(controller)
        }
    }
    
    func bindViewModel() { }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        if selectedIndex == 0 {
            onTheFirstSelected?(controller)
        } else if selectedIndex == 1 {
            onTheSecondSelected?(controller)
        } else if selectedIndex == 2 {
            onTheThirdSelected?(controller, self.navigateTabInMyConsultation)
            self.navigateTabInMyConsultation = nil
        } else if selectedIndex == 3 {
            onTheFourthSelected?(controller)
        }
    }
}
