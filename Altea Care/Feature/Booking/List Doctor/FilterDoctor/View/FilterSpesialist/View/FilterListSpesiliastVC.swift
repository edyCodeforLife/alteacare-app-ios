//
//  FilterListSpesiliastVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import UIKit
import PanModal
import RxSwift
import RxCocoa

protocol FilterListSpesialistDelegate : NSObject {
    func selectSpesialist(id : String, nameSpesialist : String)
}


class FilterListSpesiliastVC: UIViewController{
    
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var searchSpecialistTextField: UITextField!
    @IBOutlet weak var searchBarContainer: CardView!
    @IBOutlet weak var listSpecialistTableView: UITableView!
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var listOfSpecialization = [ListSpecialistModel]()
    
    
    let viewModel = FilterListSpecialistVM(
        repository: ListSpecialistRepositoryImpl(
            api: ListSpecialistAPIImpl(
                httpClient: HTTPClientImpl(identifier: BaseIdentifier())
            )
        )
    )
    
    weak var delegate : FilterListSpesialistDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupTable()
        self.viewDidLoadRelay.accept(())

    }
    
    private func bindViewModel(){
        let input = FilterListSpecialistVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.specialistList.drive { (list) in
            self.listOfSpecialization = list
            print("jumlah data", list.count)
            self.listSpecialistTableView.reloadData()
            print(self.listOfSpecialization)
        }.disposed(by: self.disposeBag)
    }
    
    
    private func setupTable(){
        let nibListSpecialist = UINib(nibName: "\(ListHospitalTableViewCell.self)", bundle: nil)
        listSpecialistTableView.register(nibListSpecialist, forCellReuseIdentifier: ListHospitalTableViewCell.identifier)
        listSpecialistTableView.dataSource = self
        listSpecialistTableView.delegate = self
    }
    
}

extension FilterListSpesiliastVC : PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    var showDragIndicator: Bool {
        return false
    }
}

extension FilterListSpesiliastVC: UITableViewDelegate{
    
}

extension FilterListSpesiliastVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSpecialization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: ListHospitalTableViewCell.identifier) as! ListHospitalTableViewCell
        let item = listOfSpecialization[indexPath.row]
        cell.nameHospitalLabel.text = item.name
        return cell
    }
    
    
}
