//
//  AddAddressRepository.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

protocol AddAddressRepository {
    func requestAdd(body: AddAddressBody) -> Single<AddAddressModel>
    func requestGetCountry() -> Single<CountryModel?>
    func requestGetProvince(body : ProvinciesBody) -> Single<ProvinceAddressModel?>
    func requestGetCity(body : CitiesBody) -> Single<CityAddressModel?>
    func requestGetDistrictKecamatan(body : DistrictBody) -> Single<DistrictKecamatanModel?>
    func requestGetSubDistrictKecamatan(body : SubDistrictBody) -> Single<SubdistrictKelurahanModel?>
}
