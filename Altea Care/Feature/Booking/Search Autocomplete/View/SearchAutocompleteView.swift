//
//  SearchAutocompleteView.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation

protocol SearchAutocompleteView: BaseView {
    var viewModel: SearchAutocompleteVM! { get set }
    var onDoctorTapped: ((String) -> Void)? { get set }
    var onSpecializationTapped: ((String, String, String) -> Void)? { get set }
    var onSymtomTapped: ((String) -> Void)? { get set }
    var onSeeMoreDoctorTapped: ((String)-> Void)? {get set }
    var onSeeMoreSpecializationTapped: ((String)-> Void)? {get set }
    var onSeeMoreSymtomTapped: ((String)-> Void)? {get set }
}
