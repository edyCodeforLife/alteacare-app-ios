//
//  UITableView+Extension.swift
//  Altea Care
//
//  Created by Hedy on 17/03/21.
//

import UIKit

extension UITableView {
    func registerNIB(with cellClass: AnyClass) {
        let className = String(describing: cellClass)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueCell<T>(with cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass)) as? T
    }
    
    func registerHeaderNIB(with headerClass: AnyClass) {
        let className = String(describing: headerClass)
        register(UINib(nibName: className, bundle: nil), forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeueHeader<T>(with headerClass: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerClass)) as? T
    }
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    func reloadRowRange(from: Int, to: Int, section: Int, animation: RowAnimation) {
        var indexPath: [IndexPath] = []
        
        for row in from...to {
            indexPath.append(IndexPath(row: row, section: section))
        }
        
        reloadRows(at: indexPath, with: animation)
    }
    
    enum scrollsTo {
        case top,bottom
    }
    
}
