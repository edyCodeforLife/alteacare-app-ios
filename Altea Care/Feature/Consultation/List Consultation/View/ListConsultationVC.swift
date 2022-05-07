//
//  ListConsultationVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class ListConsultationVC: ButtonBarPagerTabStripViewController, ListConsultationView {
    
    var ongoingView: OngoingConsultationView!
    var historyView: HistoryConsultationView!
    var cancelView: CancelConsultationView!
    var chatHistoryView: ChatHistoryView!
    var goToIndex: Int? {
        didSet {
            self.animateToSpecificPage()
        }
    }
    var isReload = false
    
    var viewGradient: CAGradientLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBackground()
        super.viewWillAppear(animated)
        self.xlPagerSetting()
        self.setupUI()
    }
    
    override func viewDidLoad() {
        self.xlPagerSetting()
        super.viewDidLoad()
        self.setupUI()
        setupBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateToSpecificPage()
        self.updateIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewGradient?.frame = view.bounds
    }
    
    private func setupUI() {
        self.setTextNavigation(title: "Telekonsultasi Saya", navigator: .none)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.navigationController?.navigationBar.isTranslucent = false
            
            
            buttonBarView.selectedBar.backgroundColor = .alteaMainColor
            buttonBarView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.navigationController?.navigationBar.isTranslucent = false

            
            buttonBarView.selectedBar.backgroundColor = .alteaMainColor
            buttonBarView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    private func animateToSpecificPage() {
        guard let goToIndex = self.goToIndex else {
            return
        }
        switch goToIndex {
        case 1:
            self.showHistoryPage()
            break
        case 2:
            self.showCanceledPage()
            break
        default:
            self.showOngoingPage()
            break
        }
    }
    
    private func setupBackground() {
        let colorTop =  #colorLiteral(red: 0.8392156863, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        let colorBottom = #colorLiteral(red: 0.5294117647, green: 0.8039215686, blue: 0.9137254902, alpha: 1)
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
        viewGradient = gradientLayer
    }
    
    private func xlPagerSetting() {
//        self.edgesForExtendedLayout = UIRectEdge()

        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarMinimumLineSpacing = 2
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .systemGray
            newCell?.label.textColor = .alteaMainColor
        }
    }
    
    func showOngoingPage() {
        self.moveToViewController(at: 0, animated: true)
    }
    
    func showHistoryPage() {
        self.moveToViewController(at: 1, animated: true)
    }
    
    func showCanceledPage() {
        self.moveToViewController(at: 2, animated: true)
    }
    
    func showConversationPage() {
        self.moveToViewController(at: 3, animated: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = ongoingView.toPresent()!
        let child_2 = historyView.toPresent()!
        let child_3 = cancelView.toPresent()!
//        let child_4 = chatHistoryView.toPresent()!
        
        guard isReload else {
//            return [child_1, child_2, child_3, child_4]
            return [child_1, child_2, child_3]
        }

//        var childViewControllers = [child_1, child_2, child_3, child_4]
        var childViewControllers = [child_1, child_2, child_3]

        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 6)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }

    func bindViewModel() { }

}
