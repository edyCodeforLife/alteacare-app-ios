//
//  DetailMemberView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol DetailMemberView: BaseView {
    var viewModel: DetailMemberVM! { get set }
    //Passing string when on changeUserData
    var onChangeUserData : ((String) -> Void)? { get set }
    var idPatient: String! { get set }
//    var onChangeUserData : (() -> Void)? { get set }
    //When tapped daftarkan sebagai akun kirim data user id, dilemapar ke kontak
    var onRegisterdAsAccount : ((String) -> Void)? { get set }
//    var onRegisterdAsAccount : (() -> Void)? { get set }
    var onDeleteMember : (() -> Void)? { get set }
}
