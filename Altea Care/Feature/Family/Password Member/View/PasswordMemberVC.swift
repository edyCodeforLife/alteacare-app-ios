//
//  PasswordMemberVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordMemberVC: UIViewController, PasswordMemberView {
    
    var viewModel: PasswordMemberVM!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        let input = PasswordMemberVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
    }

}
