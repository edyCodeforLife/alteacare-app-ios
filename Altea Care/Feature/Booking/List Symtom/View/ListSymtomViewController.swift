//
//  ListSearchResultViewController.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListSymtomViewController: UIViewController, ListSymtomView {
    var onSymtomTapped: ((SymtomResultModel) -> Void)?
    var query: String!
    var viewModel: SymtomVM!
    var searchType: search!
    
    private let searchRelay = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    private var searchResults = [SymtomResultModel]() {
        didSet {
            self.searchResultTable.reloadData()
        }
    }
    
    @IBOutlet weak var searchResultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchResultTable()
        bindViewModel()
        bindView()
        searchRelay.accept(query)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupSearchResultTable() {
        searchResultTable.dataSource = self
        searchResultTable.delegate = self
    }
    
    func bindViewModel() {
        let input = SymtomVM.Input(search: searchRelay.asObservable())
        let output = viewModel.transform(input, searchType)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.searchResults.drive { result in
            self.searchResults = result
        }.disposed(by: self.disposeBag)
    }
    
    func bindView() {
        navigationController?.navigationBar.tintColor = .info
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        switch (searchType){
        case .specialization:
            title = "Rekomendasi Dokter Spesialis"
        case .symtom:
            title = "Gejala dan Diagnosis"
        default: break
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.alteaDarker]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

    }
    
}

extension ListSymtomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        return "Menampilkan 1-\(searchResults.count) gejala dan diagnosis untuk \"\(query!)\""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }
    
}

extension ListSymtomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .alteaDarker
            header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = searchResults[indexPath.row]
        self.onSymtomTapped?(item)
    }
}
