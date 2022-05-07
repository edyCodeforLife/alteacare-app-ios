//
//  ReceiptCell.swift
//  Altea Care
//
//  Created by Admin on 15/3/21.
//

import UIKit

class ReceiptConsultationCell: UITableViewCell {
    @IBOutlet weak var ivPayment: UIImageView!
    @IBOutlet weak var lbPriceTotal: UILabel!
    @IBOutlet weak var lbPayementMethod: UILabel!
    @IBOutlet weak var ivPaymentMethod: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerNIB(with: PaymentInqFeeCell.self)
        }
    }
    
    var feeDatas : [InquiryPaymentFeeModel] = []{
        didSet{
            tableViewHeight.constant = CGFloat(feeDatas.count * 20)
            layoutIfNeeded()
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(model: ConsultationFeeModel) {
        if let urlBca = URL(string: model.paymentMethod.detail.icon ?? ""){
            self.ivPayment.kf.setImage(with: urlBca)
        }
        self.feeDatas = model.fees
        self.lbPriceTotal.text = model.priceInNumber.toCurrency()
        self.lbPayementMethod.text = model.paymentMethod.detail.name
        
    }
}

extension ReceiptConsultationCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: PaymentInqFeeCell.self) else {
            return UITableViewCell()
        }
        
        cell.feeTitleL.text = feeDatas[indexPath.row].name ?? ""
        cell.feeL.text = feeDatas[indexPath.row].price
        return cell
    }
    
}
