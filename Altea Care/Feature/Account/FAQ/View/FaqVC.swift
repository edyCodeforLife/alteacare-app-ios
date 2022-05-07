//
//  FaqVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class FaqVC: UIViewController, FaqView{
    
    @IBOutlet weak var tableViewFaq: UITableView!
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    var viewModel: FaqVM!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var faqData = [FaqModel]() {
        didSet {
            self.tableViewFaq.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.bindViewModel()
        self.setupTableView()
        self.viewDidLoadRelay.accept(())
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        
        tableView.register(FaqCell.self, forCellReuseIdentifier: "cellDropdown")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bindViewModel() {
        let input = FaqVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.faqOutput.drive { (data) in
            self.faqData = data
            self.tableView.reloadData()
            self.setupTableView()
        }.disposed(by: self.disposeBag)
    }

    
    private func setupNavigation(){
        self.setTextNavigation(title: "FAQ", navigator: .back)
    }
}

extension FaqVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return 300}
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDropdown", for: indexPath) as! FaqCell
        
        cell.data = faqData[indexPath.row]
        cell.selectionStyle = .none
        cell.animate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
