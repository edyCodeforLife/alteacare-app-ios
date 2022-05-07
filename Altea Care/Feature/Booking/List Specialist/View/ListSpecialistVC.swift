//
//  ListSpecialistVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListSpecialistVC: UIViewController, ListSpecialistView {
    var isShowBackButton: Bool!
    var onBackButtonPressed: (() -> Void)?
    var viewModel: ListSpecialistVM!
    var onSpecialistTapped: ((String, String) -> Void)?
    @IBOutlet weak var vBackground: UIView!
    private let searchQueryRelay = PublishRelay<String?>()
    private var model = [ListSpecialistModel]() {
        didSet {
            self.cvSpesialist.reloadData()
            if searchQuery.isEmpty {
                searchQueryHeight.constant = 0.0
            } else {
                searchQueryLabel.text = "Menampilkan 1 - \(model.count) Rekomendasi Spesialis untuk \"\(searchQuery!)\""
            }
        }
    }
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchQueryLabel: UILabel!
    @IBOutlet weak var searchQueryHeight: NSLayoutConstraint!
    var searchQuery: String!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var cvSpesialist: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func dummyButton(_ sender: Any) {
        self.onSpecialistTapped?("", "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.searchQueryRelay.accept(searchQuery)
        self.setupCollectionView()
        self.navigationController?.navigationBar.isHidden = true
        searchQueryLabel.textColor = .alteaDarker
        if !searchQuery.isEmpty {
            navigationTitleLabel.text = "Rekomendasi Dokter Spesialis"
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.onBackButtonPressed?()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
    }
    
    func bindViewModel() {
        
        let input = ListSpecialistVM.Input(searchQuery: searchQueryRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            //            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.specialistList.drive { (list) in
            self.model = list
        }.disposed(by: self.disposeBag)
        
        backButton.isHidden = !isShowBackButton
    }
    
    func setupCollectionView() {
        cvSpesialist.registerNIBForCell(with: SpesialistCollectionViewCell.self)
        cvSpesialist.dataSource = self
        cvSpesialist.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: ((cvSpesialist.frame.width-40)/3.0), height: ((cvSpesialist.frame.width-65)/3.0))
        self.cvSpesialist.collectionViewLayout = flowLayout
        cvSpesialist.reloadData()
    }
    
}

extension ListSpecialistVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: SpesialistCollectionViewCell.self, for: indexPath)!
        if (model[indexPath.row].iconSmall.isEmpty) ||  (model[indexPath.row].iconSmall == "-"){
            cell.ivSpecialistName.image = UIImage(named: "IconAltea")
        } else {
            if let url = URL(string: model[indexPath.row].iconSmall) {
                cell.ivSpecialistName.kf.setImage(with: url)
            }
        }
        
        cell.lbSpecialistName.text = self.model[indexPath.row].name
        
        return cell
    }
    
}

extension ListSpecialistVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let target = self.model[indexPath.row]
        self.setupTracker(categoryId: target.specializationId, specialistCategoryName: target.name)
        self.onSpecialistTapped?(target.specializationId ?? "", target.name ?? "")
    }
}

//MARK: - Setup Tracker
extension ListSpecialistVC {
    
    func setupTracker(categoryId: String?, specialistCategoryName: String?) {
        self.track(.specialistCategory(AnalyticsSpecialistCategory(categoryId: categoryId, specialistCategoryName: specialistCategoryName)))
        self.defaultAnalyticsService.trackUserAttribute(specialistCategoryName, key: AnalyticsCustomAttributes.lastSpecialistPick.rawValue)
    }
}
