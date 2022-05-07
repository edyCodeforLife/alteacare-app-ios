//
//  ChatHistoryVC.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class ChatHistoryVC: UIViewController, IndicatorInfoProvider, ChatHistoryView {
    
    var viewModel: ChatHistoryVM!
    var onChatTapped: (() -> Void)?
    
    @IBOutlet weak var label: ACLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private lazy var refreshControl = UIRefreshControl()
    
    private var model = [ChatHistoryModel]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setDummy()
        self.setupTableView()
        self.bindViewModel()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }

    func bindViewModel() {
        let input = ChatHistoryVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Percakapan")
    }

    private func setupUI() {
        label.textColor = .alteaDark3
        setupRefresh()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "ChatHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatHistoryCell")
        
        if model.count == 0 {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 49, right: 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    private func setDummy() {
        self.model.append(ChatHistoryModel(title: "Medical Advisor", message: "Ok baik.", date: "12/01/2020", counter: 0))
        self.model.append(ChatHistoryModel(title: "Medical Advisor", message: "Silahkan hubungi lagi nanti, nanti aja tapi kapan kapan", date: "01/03/2020", counter: 2))
        self.model.append(ChatHistoryModel(title: "Medical Advisor", message: "Perlu pemeriksaan lebih lanjut, lanjut kang jangan kasih kendor hayoooo kamu pasti bisa ya", date: "12/01/2021", counter: 100))
        self.model.append(ChatHistoryModel(title: "Medical Advisor", message: "Ok baik.", date: "12/01/2020", counter: 10))
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc private func refreshAction() {
        //do something
    }
    
}

extension ChatHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatHistoryCell", for: indexPath) as! ChatHistoryCell
        let target = self.model[indexPath.row]
        cell.setCell(model: target)
        return cell
    }
}

extension ChatHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ChatManager.shared.show(self, identity: "", accessToken: "", uniqueRoom: "", roomName: "")
    }
}
