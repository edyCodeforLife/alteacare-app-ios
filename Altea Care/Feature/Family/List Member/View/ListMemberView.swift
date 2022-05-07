//
//  ListMemberView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol ListMemberView: BaseView {
    var viewModel: ListMemberVM! { get set }
    var onCreateNewFamilyMember: (() -> Void)? { get set }
    var onDetailMember: ((MemberModel) -> Void)? { get set }
    var onMakeAsMainAccount: (() -> Void)? { get set }
    var isReadOnly: Bool! { get set }
}
