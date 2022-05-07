//
//  ListSearchResultView.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//
import Foundation

protocol ListSymtomView: BaseView {
    var viewModel: SymtomVM! { get set }
    var query: String! { get set }
    var searchType: search! { get set }
    var onSymtomTapped: ((SymtomResultModel) -> Void)? { get set}
}
