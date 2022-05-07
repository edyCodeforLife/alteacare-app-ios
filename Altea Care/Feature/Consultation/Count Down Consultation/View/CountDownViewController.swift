//
//  CountDownViewController.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 16/12/21.
//

import UIKit
import PanModal
import RxSwift

class CountDownViewController: UIViewController, CountDownView {
    var schedule: Schedule!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var dateTimeBar: DateTimeBar!
    func bindViewModel() {}
    let disposeBag = DisposeBag()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        setupBinding()
        UpdateTime()
    }
    
    @objc func UpdateTime() {
        countDownLabel.text = schedule.getCountDownLabel()
        if(schedule.isConsultationStarted()) {
            timer.invalidate()
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    private func bindView() {
        dateTimeBar.clipsToBounds = true
        dateTimeBar.leftIcon.tintColor = .info
        dateTimeBar.leftLabel.textColor = .black
        dateTimeBar.rightIcon.tintColor = .info
        dateTimeBar.rightLabel.textColor = .black
        dateTimeBar.leftLabel.text = schedule.dateString.dateIndonesiaStandard()
        dateTimeBar.rightLabel.text = schedule.time
        closeButton.setTitle("", for: .normal)
        closeButton.tintColor = .info
        countDownLabel.textColor = .error
    }
    
    private func setupBinding() {
        closeButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}

extension CountDownViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    var showDragIndicator: Bool {
        return false
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(250)
    }
}
