//
//  SearchAutocompleteVC.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchAutocompleteVC: UIViewController, SearchAutocompleteView {
    var onSpecializationTapped: ((String, String, String) -> Void)?
    var onSeeMoreDoctorTapped: ((String) -> Void)?
    var onSeeMoreSpecializationTapped: ((String) -> Void)?
    var onSeeMoreSymtomTapped: ((String) -> Void)?
    var onSymtomTapped: ((String) -> Void)?
    var onDoctorTapped: ((String) -> Void)?
    
    var viewModel: SearchAutocompleteVM!
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let searchRelay = BehaviorRelay<String?>(value: nil)
    var resultSearch = ""
    private var modelSearch = [SearchEverythingsModel?]() {
        didSet {
            self.tblvSearchEverything.reloadData()
        }
    }
    private var metaSearch: MetaSearchModel?
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tblvSearchEverything: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupCell()
        self.viewDidLoadRelay.accept(())
        self.searchRelay.accept("")
        self.setupUI()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        let input = SearchAutocompleteVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), search: searchRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.searchEverything.drive { (list) in
            self.modelSearch = list
        }.disposed(by: self.disposeBag)
        output.meta.drive { meta in
            self.metaSearch = meta
        }.disposed(by: disposeBag)
    }
    
    
    func setupUI() {
        self.backButton.rx.tap
            .do(onNext: { [unowned self] in
                
            }).subscribe(onNext: {[unowned self] in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }, onError: { _ in
                
            }).disposed(by: self.disposeBag)
                
                self.tblvSearchEverything.delegate = self
                self.tblvSearchEverything.dataSource = self
                
                self.tfSearch.delegate = self
                self.tfSearch.returnKeyType = .search
                self.tfSearch.sendActions(for: .editingDidEnd)
                self.tfSearch.addTarget(self, action: #selector(actionSearch), for: UIControl.Event.editingChanged)
                
                self.tfSearch.rx.text.orEmpty
                .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] (text) in
                    guard let self = self else { return }
                    if text.isEmpty || text == " " {
                        return
                    }
                    
                    self.resultSearch = text
                    self.searchAction()
                }).disposed(by: disposeBag)
                }
    
    internal func searchAction() {
        self.searchRelay.accept(self.resultSearch)
        self.track(.searchKeyword(AnalyticsSearchKeyword(searchResult: self.resultSearch)))
        self.defaultAnalyticsService.trackUserAttribute(self.resultSearch, key: AnalyticsCustomAttributes.lastSearch.rawValue)
    }
    
    func setupCell() {
        let nibListSpecialization = UINib(nibName: "SearchEverythingTableViewCell", bundle: nil)
        self.tblvSearchEverything.register(nibListSpecialization, forCellReuseIdentifier: "SearchEverythingTableViewCell")
        let nibListDoctor = UINib(nibName: "SearchDoctorEverythingTableViewCell", bundle: nil)
        self.tblvSearchEverything.register(nibListDoctor, forCellReuseIdentifier: "SearchDoctorEverythingTableViewCell")
    }
    
    @objc private func actionSearch(_ textField: UITextField) {
        //        self.resultSearch = textField.text ?? ""
        //        self.searchRelay.accept(self.resultSearch)
        //        self.defaultAnalyticsService.trackUserAttribute(self.resultSearch, key: AnalyticsCustomAttributes.lastSearch.rawValue)
    }
    
}

extension SearchAutocompleteVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelSearch.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelSearch[section]?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = self.modelSearch[indexPath.section]?.data[indexPath.row]
        switch target!.type {
        case .doctor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDoctorEverythingTableViewCell") as! SearchDoctorEverythingTableViewCell
            cell.lbExperience.text = target?.experience
            if let urlPhoto = URL(string: target?.photo ?? ""){
                cell.ivPotoProfil.kf.setImage(with: urlPhoto)
            }
            cell.lbSpecialization.text = target?.specialization
            cell.lbName.text = target?.name
            return cell
        case .specialization:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchEverythingTableViewCell") as! SearchEverythingTableViewCell
            cell.lbName.text = target?.name
            return cell
        case .symtom :
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchEverythingTableViewCell") as! SearchEverythingTableViewCell
            cell.lbName.text = target?.name
            return cell
        }
    }
    
}

extension SearchAutocompleteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width-15, height: 40))
        label.text = self.modelSearch[section]?.searchType.rawValue
        label.font = UIFont(name: "Inter-Bold", size:15)
        label.textColor = .alteaDarker
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let item = modelSearch[section]
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))
        view.backgroundColor = .white
        let searchModel = self.modelSearch[section]!
        let title = "Lihat \(searchModel.searchType.rawValue) Lainnya"
        let button = UIButton(frame: CGRect(x: 16, y: 10, width: view.frame.width-32, height: 28))
        
        button.setupSecondaryButton(title: title){
            switch searchModel.searchType{
            case .doctor:
                self.onSeeMoreDoctorTapped?(self.resultSearch)
            case .symtom:
                self.onSeeMoreSymtomTapped?(self.resultSearch)
            case .specialization:
                self.onSeeMoreSpecializationTapped?(self.resultSearch)
            }
        }
        view.addSubview(button)
        
        if resultSearch.isEmpty {
            return nil
        }
        switch item?.searchType {
        case .some(.doctor) :
            if let meta = metaSearch {
                if meta.totalDoctort > 5 {
                    return view
                }
            }
            
        case .some(.symtom):
            if let meta = metaSearch {
                if meta.totalSymptom > 5 {
                    return view
                }
            }
        case .some(.specialization):
            if let meta = metaSearch {
                if meta.totalSpecialization > 5 {
                    return view
                }
            }
        case .none:
            return nil

        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let item = modelSearch[section]
        if resultSearch.isEmpty {
            return .leastNormalMagnitude
        }
        switch item?.searchType {
        case .some(.doctor) :
            if let meta = metaSearch {
                if meta.totalDoctort > 5 {
                    return 55
                }
            }
            
        case .some(.symtom):
            if let meta = metaSearch {
                if meta.totalSymptom > 5 {
                    return 55
                }
            }
        case .some(.specialization):
            if let meta = metaSearch {
                if meta.totalSpecialization > 5 {
                    return 55
                }
            }
        case .none:
            return .leastNormalMagnitude

        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let target = self.modelSearch[indexPath.section]?.data[indexPath.row]
        switch target!.type {
        case .doctor:
            self.setupTracker(filterSpecialistCategory: nil, filterDoctorName: target?.name, filterSymptom: nil)
            self.onDoctorTapped?(target!.id ?? "")
        case .specialization:
            self.setupTracker(filterSpecialistCategory: target?.name, filterDoctorName: nil, filterSymptom: nil)
            self.onSpecializationTapped?(target?.id ?? "", target?.name ?? "", self.tfSearch.text ?? "")
        case .symtom :
            self.setupTracker(filterSpecialistCategory: nil, filterDoctorName: nil, filterSymptom: target?.name)
            self.onSymtomTapped?(target!.name ?? "")
        }
    }
    
}

//MARK: - Setup Tracker
extension SearchAutocompleteVC {
    
    func setupTracker(filterSpecialistCategory: String?, filterDoctorName: String?, filterSymptom: String?) {
        self.track(.searchResult(AnalyticsSearchResult(filterSpecialistCategory: filterSpecialistCategory, filterDoctorName: filterDoctorName, filterSymptom: filterSymptom)))
    }
}

extension SearchAutocompleteVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if text.isNotEmpty && text != " " {
            self.resultSearch = text
            self.searchAction()
        }
        return true
    }
}
