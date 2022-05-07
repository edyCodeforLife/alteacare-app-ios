//
//  VMModuleFactory.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol VMModuleFactory {
    // MARK: - Auth
    func makeLoginVM() -> LoginVM
    func makeRegisterVM() -> RegisterVM
    func makeRegisterReviewVM() -> RegisterReviewVM
    func makeContactFieldVM() -> ContactFieldVM
    func makeCreatePasswordVM() -> CreatePasswordVM
    func makeTermConditionVM() -> TermAndConditionVM
    func makeChangeEmailAddressVM() -> ChangeEmailAddressVM
    func makeEmailVerificationVM() -> EmailVerificationVM
    func makeInitialForgotPasswordVM() -> ForgotPasswordVM
    func makeReverificationEmailVM() -> ReverificationEmailVM
    func makeCreateNewPasswordVM() -> CreateNewPasswordVM
    func makeSwitchAccountVM() -> SwitchAccountVM
    
    // MARK: - Dashboard
    func makeHomeVM() -> HomeVM
    
    // MARK: - Filter Doctor
    func makeFilterDoctorVM() -> FilterDoctorVM
    
    // MARK: - Booking
    func makeListSpecialistVM() -> ListSpecialistVM
    func makeListDoctorVM() -> ListDoctorVM
    func makeDetailDoctorVM() -> DetailDoctorVM
    func makeCreateBookingVM() -> CreateBookingVM
    func makeReviewBookingVM() -> ReviewBookingVM
    func makeSearchAutocompleteVM() -> SearchAutocompleteVM
    func makeLoginConsultationVM() -> LoginConsultationVM
    func makeDrawerCallBookingVM() -> DrawerCallBookingVM
    func makeSearchResultVM() -> SymtomVM
    
    // MARK: - Consultation
    func makeInitialScreeningVM() -> InitialScreeningVM
    func makeReviewScreeningVM() -> ReviewScreeningVM
    func makeOngogingConsultationVM() -> OngoingConsultationVM
    func makeHistoryConsultationVM() -> HistoryConsultationVM
    func makeCancelConsultationVM() -> CancelConsultationVM
    func makeConsulationExpiredVM() -> ConsultationExpiredVM
    func makeChatHistoryVM() -> ChatHistoryVM
    func makePatientDataVM() -> PatientDataVM
    func makeMedicalResumeVM() -> MedicalResumeVM
    func makeMedicalDocumentVM() -> MedicalDocumentVM
    func makeReceiptVM() -> ReceiptVM
    func makeRequestCancelVM() -> RequestCancelVM
    
    // MARK: - Payment
    func makeInquiryPaymentVM() -> InquiryPaymentVM
    func makeReviewPaymentVM() -> ReviewPaymentVM
    func makePaymentMethodVM() -> PaymentMethodVM
    func makeWebViewAlteaVM() -> AlteaPaymentWebViewVM
    func makeVoucherVM() -> VoucherVM
    
    // MARK: - Account
    func makeAccountVM() -> AccountVM
    func makeInitialSetAccountVM() -> InitialSetAccountVM
    func makeChangePasswordVM() -> ChangePasswordVM
    func makeOldPasswordVM() -> OldPasswordVM
    func makeContactUsVM() -> ContactUsVM
    func makeChangePersonalDataVM() -> ChangePersonalDataVM
    func makeFaqVM() -> FaqVM
    func makeInitialChangeProfileVM() -> InitialChangeProfileVM
    func makeInitialChangePhoneNumberVM() -> InitialChangePhoneNumberVM
    func makeVerifyPhoneNumberVM() -> VerifyPhoneNumberVM
    func makeInitialSettingAccountVM() -> InitialSetAccountVM
    func makeTermConditionAccountVM() -> TermConditionVM
    func makeChangeEmailVM() -> ChangeEmailVM
    func makeVerifyChangeEmailVM() -> VerifyChangeEmailVM
    
    //MARK: - Family
    func makeListMemberVM() -> ListMemberVM
    func makeAddMemberVM() -> AddMemberVM
    func makeEditMemberVM() -> EditMemberVM
    func makeVerifyMemberVM() -> VerifyMemberVM
    func makeRegisterMemberVM() -> RegisterMemberVM
    func makePasswordMemberVM() -> PasswordMemberVM
    func makeDetailMemberVM() -> DetailMemberVM
    func makeListAddressVM() -> ListAddressVM
    func makeAddAddressVM() -> AddAddressVM
    func makeEditAddressVM() -> EditAddressVM
}
