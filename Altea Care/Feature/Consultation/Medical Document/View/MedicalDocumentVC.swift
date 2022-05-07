//
//  MedicalDocumentVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//
import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

enum documentSection {
    case titles(String)
    case fromAlteaCare
    case selfUploaded
    case newest
}

class MedicalDocumentVC: UIViewController, IndicatorInfoProvider, MedicalDocumentView {

    var viewModel: MedicalDocumentVM!
    var id: String!
    
    private let disposeBag = DisposeBag()
    private let idRelay = BehaviorRelay<String?>(value: nil)
    private lazy var refreshControl = UIRefreshControl()
    
    private var model = [MedicalDocumentModel]() {
        didSet {
            self.emptyView.isHidden = model.flatMap{$0.content}.count > 0
            self.tableView.reloadData()
        }
    }
    
    private var tableViewItems: [documentSection] = [documentSection]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupRefresh()
        self.bindViewModel()
        self.idRelay.accept(self.id)
    }

    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshAction() {
        self.idRelay.accept(self.id)
    }
    
    func bindViewModel() {
        let input = MedicalDocumentVM.Input(fetch: self.idRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.data.drive { (model) in
            self.model = model
        }.disposed(by: self.disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Dokumen Medis")
    }
    
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "MedicalDocumentCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MedicalDocumentCell")
    }
}

extension MedicalDocumentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model[section].content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalDocumentCell", for: indexPath) as! MedicalDocumentCell
        let target = model[indexPath.section].content[indexPath.row]
        cell.buttonTapped = { [weak self] in
            guard let self = self else { return }
            guard let url = target.url else { return }
            self.showDocument(url: url, title: target.title)
        }
        cell.setDocumentCell(model: target)
        return cell
    }
    
    private func showDocument(url: String, title: String?) {
        let resource: WebviewResourceType = .web(url: url)
        DocumentManager.shared.show(self, resource: resource, title: title)
    }
    
}

extension MedicalDocumentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.model[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let target = self.model[indexPath.section].content[indexPath.row]
        guard let url = target.url else { return }
        self.showDocument(url: url, title: target.title)
    }
    
}
