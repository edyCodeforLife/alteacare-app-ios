//
//  TermConditionViewController.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class TermConditionViewController: UIViewController, TermConditionView{
    
    var onUnderstandTapped: (() -> Void)?
    var viewModel: TermConditionVM!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var buttonUnder: UIButton!
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupNavigation()
        self.setupActiveButton(button: buttonUnder)
        self.viewDidLoadRelay.accept(())
    }
    
    func bindViewModel() {
        let input = TermConditionVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.termCondition.drive { (termData) in
            self.setupLabelTermCondition(model: termData)
        }.disposed(by: self.disposeBag)
    }
    
    func setupLabelTermCondition(model : TermConditionModel?){
        self.labelContent.attributedText = (model?.text ?? "").htmlAttributedString()
//        self.labelContent.font =  UIFont(name: "Inter-Regular", size: 12)
    }
    
    @IBAction func buttonUnderTapped(_ sender: Any) {
        self.onUnderstandTapped?()
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Syarat Dan Ketentuan", navigator: .back)
    }
}
