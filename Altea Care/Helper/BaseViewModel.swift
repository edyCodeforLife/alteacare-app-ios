//
//  BaseViewModel.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
