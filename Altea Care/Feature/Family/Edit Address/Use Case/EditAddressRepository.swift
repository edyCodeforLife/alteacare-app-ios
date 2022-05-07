//
//  EditAddressRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol EditAddressRepository {
    func requestDetail(body: DetailAddressBody) -> Single<DetailAddressModel>
    func requestEdit(id: String, body: EditAddressBody) -> Single<Bool>
    func requestGetCountry() -> Single<CountryModel?>
    func requestGetProvince(body : ProvinciesBody) -> Single<ProvinceAddressModel?>
    func requestGetCity(body : CitiesBody) -> Single<CityAddressModel?>
    func requestGetDistrictKecamatan(body : DistrictBody) -> Single<DistrictKecamatanModel?>
    func requestGetSubDistrictKecamatan(body : SubDistrictBody) -> Single<SubdistrictKelurahanModel?>
}
