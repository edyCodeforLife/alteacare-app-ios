//
//  DetailConsultationVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class DetailConsultationVC: ButtonBarPagerTabStripViewController, DetailConsultationView {
    var goDashboard: (() -> Void)?
    var onBackTapped: (() -> Void)?
    var patientView: PatientDataView!
    var resumeView: MedicalResumeView!
    var documentView: MedicalDocumentView!
    var receiptView: ReceiptView!
    var isReload = false
    var isRoot: Bool = false
    var goToIndex: Int?
    
    override func viewDidLoad() {
        self.setupXlPagerTab()
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateToSpecificPage()
    }
    
    private func setupUI() {
        self.setupNavigation()
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
    
    private func setupXlPagerTab() {
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarMinimumLineSpacing = 2
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .systemGray
            newCell?.label.textColor = .alteaMainColor
        }
    }
    
    private func animateToSpecificPage() {
        guard let goToIndex = self.goToIndex else {
            return
        }
        switch goToIndex {
        case 1:
            self.showMedicalResume()
            break
        case 2:
            self.showMedicalDocument()
            break
        case 3:
            self.showReceipt()
            break
        default:
            self.showPatietData()
            break
        }
    }
    
    func showPatietData() {
        self.moveToViewController(at: 0, animated: true)
    }
    
    func showMedicalResume() {
        self.moveToViewController(at: 1, animated: true)
    }
    
    func showMedicalDocument() {
        self.moveToViewController(at: 2, animated: true)
    }
    
    func showReceipt() {
        self.moveToViewController(at: 3, animated: true)
    }
    
    private func setupNavigation() {
        if isRoot{
            self.setTextNavigation(title: "Detail Telekonsultasi", navigator: .close, navigatorCallback: #selector(onCloseAction))
            
        }else{
            self.setTextNavigation(title: "Detail Telekonsultasi", navigator: .back, navigatorCallback: #selector(onBackAction))
        }
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func onCloseAction() {
        self.goDashboard?()
    }
    
    @objc private func onBackAction() {
            self.onBackTapped?()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = patientView.toPresent()!
        let child_2 = resumeView.toPresent()!
        let child_3 = documentView.toPresent()!
        let child_4 = receiptView.toPresent()!
        
        guard isReload else {
            return [child_1, child_2, child_3, child_4]
        }

        var childViewControllers = [child_1, child_2, child_3, child_4]

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
