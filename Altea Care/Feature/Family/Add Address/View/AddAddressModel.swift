//
//  AddAddressModel.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

struct AddAddressModel {
    let version : String?
    let status : Bool?
    let message : String?
    let data : String?
}

struct SubdistrictKelurahanModel {
    let status: Bool
    let message: String
    let data: [SubdistrictKelurahanModelData]
}

// MARK: - Datum
struct SubdistrictKelurahanModelData{
    let nameSubdistrictKelurahan : String
    let idKelurahan : String

    enum CodingKeys: String, CodingKey {
        case nameSubdistrictKelurahan
        case idKelurahan
    }
}

struct DistrictKecamatanModel {
    let status: Bool
    let message: String
    let data: [DistrictKecamatanModelData]
}

// MARK: - Datum
struct DistrictKecamatanModelData{
    let nameDistrictKecamatan : String
    let idKecamatan : String

    enum CodingKeys: String, CodingKey {
        case nameDistrictKecamatan
        case idKecamatan
    }
}

struct CityAddressModel {
    let status: Bool
    let message: String
    let data: [CityAddressModelData]
}

// MARK: - Datum
struct CityAddressModelData{
    let nameCity : String
    let idCity : String

    enum CodingKeys: String, CodingKey {
        case nameProvince
        case idProvince
    }
}

struct ProvinceAddressModel {
    let status: Bool
    let message: String
    let data: [ProvinceAddressModeldata]
}

// MARK: - Datum
struct ProvinceAddressModeldata{
    let nameProvince : String
    let idProvince : String

    enum CodingKeys: String, CodingKey {
        case nameProvince
        case idProvince
    }
}
