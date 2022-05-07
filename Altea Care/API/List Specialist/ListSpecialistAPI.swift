//
//  ListSpecialistAPI.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 11/05/21.
//

import Foundation
import RxSwift

protocol ListSpecialistAPI: ClientAPI {
    func requestSpecializations(_ req: SpecializationsRequest) -> Single<ListSpecialistResponse>
    func requestSpecialistList(_ q: String) -> Single<ListSpecialistResponse>
    func requestSpecialistPopular() -> Single<ListSpecialistResponse>
}
