//
//  FilterDoctorVC+Extension+CollectionView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 07/10/21.
//

import Foundation
import UIKit
import PanModal

extension FilterDoctorVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
