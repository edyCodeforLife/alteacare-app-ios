//
//  DoctorDetailsAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation
import RxSwift

protocol DoctorDetailsAPI : ClientAPI {
    func requestDoctorDetails(id : String) -> Single<DoctorDetailsResponse>
}
