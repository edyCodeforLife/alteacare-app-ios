//
//  VMModuleFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

extension ModuleFactoryImpl: VMModuleFactory {
    
    
    // MARK: - Auth
    func makeLoginVM() -> LoginVM {
        return LoginVM(repository: self.makeLoginRepo())
    }
    
    func makeChangeEmailAddressVM() -> ChangeEmailAddressVM {
        return ChangeEmailAddressVM(repository: self.makeChangeEmailAddressRepo())
    }
    
    func makeEmailVerificationVM() -> EmailVerificationVM {
        return EmailVerificationVM(repository: self.makeEmailVerificationRepo())
    }
    
    func makeInitialForgotPasswordVM() -> ForgotPasswordVM {
        return ForgotPasswordVM(repository: self.makeInitialForgotPasswordRepo())
    }
    
    func makeReverificationEmailVM() -> ReverificationEmailVM {
        return ReverificationEmailVM(repository: self.makeReverificationEmailRepo())
    }
    
    func makeCreateNewPasswordVM() -> CreateNewPasswordVM {
        return CreateNewPasswordVM(repository: self.makeCreateNewPasswordRepo())
    }
    
    func makeTermConditionVM() -> TermAndConditionVM {
        return TermAndConditionVM(termCondition: self.makeTermAndConditionRepo())
    }
    
    func makeRegisterVM() -> RegisterVM {
        return RegisterVM(repository: self.makeRegisterRepo())
    }
    
    func makeRegisterReviewVM() -> RegisterReviewVM {
        return RegisterReviewVM(repository: self.makeRegisterReviewRepo())
    }
    
    func makeContactFieldVM() -> ContactFieldVM {
        return ContactFieldVM(repository: self.makeContactFieldRepo())
    }
    
    func makeCreatePasswordVM() -> CreatePasswordVM {
        return CreatePasswordVM(repository: self.makeCreatePasswordRepo())
    }
    
    func makeSuccessRegisterVM() -> SuccessRegisterVM{
        return SuccessRegisterVM(repository: self.makeSuccessRegisterRepo())
    }
    
    func makeSwitchAccountVM() -> SwitchAccountVM {
        return SwitchAccountVM(repository: makeSwitchAccountRepo())
    }
    
    // MARK: - Dashboard
    func makeHomeVM() -> HomeVM {
        return HomeVM(repository: self.makeHomeRepo(), settingRepository: self.makeSettingRepo())
    }
    
    func makeForceUpdateVM() -> ForceUpdateVM{
        return ForceUpdateVM(repository: self.makeForceUpdateRepo())
    }
    
    // MARK: - Filter Doctor
    func makeFilterDoctorVM() -> FilterDoctorVM {
        return FilterDoctorVM()
    }
    
    // MARK: - Booking
    func makeListSpecialistVM() -> ListSpecialistVM {
        return ListSpecialistVM(repository: self.makeListSpecialistRepo())
    }

    func makeListDoctorVM() -> ListDoctorVM {
        return ListDoctorVM(
            repositoryDoctors: self.makeListDoctorRepo(),
            repositorySearch: self.makeSearchEverythingRepo(),
            repositorySpecialists: self.makeListSpecialistRepo(),
            repositoryHospitals: self.makeListHospitalRepo())
    }
    
    func makeDetailDoctorVM() -> DetailDoctorVM {
        return DetailDoctorVM(repository: self.makeDetailDoctorRepo())
    }
    
    func makeCreateBookingVM() -> CreateBookingVM {
        return CreateBookingVM(repository: self.makeCreateBookingRepo())
    }
    
    func makeReviewBookingVM() -> ReviewBookingVM {
        return ReviewBookingVM(repository: self.makeReviewBookingRepo(), repositoryPatient: self.makePatientDataRepo())
    }
    
    func makeSearchAutocompleteVM() -> SearchAutocompleteVM {
        return SearchAutocompleteVM(repository: self.makeSearchEverythingRepo())
    }
    
    func makeLoginConsultationVM() -> LoginConsultationVM {
        return LoginConsultationVM(repository: self.makeLoginOtherPatientRepo())
    }
    
    func makeDrawerCallBookingVM() -> DrawerCallBookingVM {
        return DrawerCallBookingVM(repository: self.makeDrawerCallBookingRepo(),settingRepository: self.makeSettingRepo())
    }
    
    func makeSearchResultVM() -> SymtomVM {
        return SymtomVM(repository: self.makeSearchResultRepo())
    }
    
    // MARK: - Consultation
    func makeInitialScreeningVM() -> InitialScreeningVM {
        return InitialScreeningVM(repository: self.makeInitialScreeningRepo())
    }
    
    func makeReviewScreeningVM() -> ReviewScreeningVM {
        return ReviewScreeningVM(repository: self.makeReviewScreeningRepo())
    }
    
    func makeOngogingConsultationVM() -> OngoingConsultationVM {
        return OngoingConsultationVM(repository: self.makeOngogingConsultationRepo(),settingRepository: self.makeSettingRepo())
    }
    
    func makeHistoryConsultationVM() -> HistoryConsultationVM {
        return HistoryConsultationVM(repository: self.makeHistoryConsultationRepo())
    }
    
    func makeCancelConsultationVM() -> CancelConsultationVM {
        return CancelConsultationVM(repository: self.makeCancelConsultationRepo())
    }
    
    func makeChatHistoryVM() -> ChatHistoryVM {
        return ChatHistoryVM(repository: self.makeChatHistoryRepo())
    }
    
    func makePatientDataVM() -> PatientDataVM {
        return PatientDataVM(repository: self.makePatientDataRepo())
    }
    
    func makeMedicalResumeVM() -> MedicalResumeVM {
        return MedicalResumeVM(repository: self.makeMedicalResumeRepo())
    }
    
    func makeMedicalDocumentVM() -> MedicalDocumentVM {
        return MedicalDocumentVM(repository: self.makeMedicalDocumentRepo())
    }
    
    func makeReceiptVM() -> ReceiptVM {
        return ReceiptVM(repository: self.makeReceiptRepo())
    }
    
    func makeRequestCancelVM() -> RequestCancelVM {
        return RequestCancelVM(repository: self.makeRequestCanceRepo())
    }
    
    // MARK: - Payment
    func makeInquiryPaymentVM() -> InquiryPaymentVM {
        return InquiryPaymentVM(repository: self.makeInquiryPaymentRepo())
    }
    
    func makeReviewPaymentVM() -> ReviewPaymentVM {
        return ReviewPaymentVM(repository: self.makeReviewPaymentRepo())
    }
    
    func makePaymentMethodVM() -> PaymentMethodVM {
        return PaymentMethodVM(repository: self.makePaymentMethodRepo())
    }
    
    func makeConsulationExpiredVM() -> ConsultationExpiredVM{
        return ConsultationExpiredVM(repository: self.makeConsulationExpiredRepo())
    }
    
    
    func makeWebViewAlteaVM() -> AlteaPaymentWebViewVM{
        return AlteaPaymentWebViewVM(repository: self.makeAlteaPaymentRepo())
    }
    
    func makeVoucherVM() -> VoucherVM{
        return VoucherVM(repository: self.makeVoucherRepo())
    }
    
    // MARK: - Account
    func makeAccountVM() -> AccountVM {
        return AccountVM(repository: self.makeAccountRepo())
    }
    
    func makeInitialSetAccountVM() -> InitialSetAccountVM {
        return InitialSetAccountVM(repository: self.makeInitialSetAccountRepo())
    }
    
    func makeOldPasswordVM() -> OldPasswordVM {
        return OldPasswordVM(repository: self.makeOldPasswordRepo())
    }
    
    func makeChangePasswordVM() -> ChangePasswordVM {
        return ChangePasswordVM(repository: self.makeChangePasswordRepo())
    }
    
    func makeContactUsVM() -> ContactUsVM {
        return ContactUsVM(repository: self.makeContactUsRepo())
    }
    
    func makeFaqVM() -> FaqVM {
        return FaqVM(repository: self.makeFaqsRepo())
    }
    
    func makeInitialChangeProfileVM() -> InitialChangeProfileVM {
        return InitialChangeProfileVM(repository: self.makeInitialChangeProfileRepo())
    }
    
    func makeInitialChangePhoneNumberVM() -> InitialChangePhoneNumberVM {
        return InitialChangePhoneNumberVM(repository: makeInitialChangePhoneNumberRepo())
    }
    
    func makeVerifyPhoneNumberVM() -> VerifyPhoneNumberVM {
        return VerifyPhoneNumberVM(repository: makeVerifyPhoneNumberRepo())
    }
    
    func makeInitialSettingAccountVM() -> InitialSetAccountVM {
        return InitialSetAccountVM(repository: makeInitialSetAccountRepo())
    }
    
    func makeChangePersonalDataVM() -> ChangePersonalDataVM {
        return ChangePersonalDataVM(repository: makeChangePersonalDataRepo())
    }
    
    func makeTermConditionAccountVM() -> TermConditionVM {
        return TermConditionVM(repository: makeTermConditionRepo())
    }
    
    func makeChangeEmailVM() -> ChangeEmailVM {
        return ChangeEmailVM(repository: makeChangeEmailRepo())
    }
    
    func makeVerifyChangeEmailVM() -> VerifyChangeEmailVM {
        return VerifyChangeEmailVM(repository: makeChangeEmailVerifyRepo())
    }
    
    //MARK: - Family
    func makeListMemberVM() -> ListMemberVM {
        return ListMemberVM(repository: makeListMemberRepo())
    }
    
    func makeAddMemberVM() -> AddMemberVM {
        return AddMemberVM(repository: makeAddMemberRepo())
    }
    
    func makeEditMemberVM() -> EditMemberVM {
        return EditMemberVM(repository: makeEditMemberRepo())
    }
    
    func makeVerifyMemberVM() -> VerifyMemberVM {
        return VerifyMemberVM(repository: makeVerifyMemberRepo())
    }
    
    func makeRegisterMemberVM() -> RegisterMemberVM {
        return RegisterMemberVM(repository: makeRegisterMemberRepo())
    }
    
    func makePasswordMemberVM() -> PasswordMemberVM {
        return PasswordMemberVM(repository: makePasswordMemberRepo())
    }
    
    func makeDetailMemberVM() -> DetailMemberVM {
        return DetailMemberVM(repository: makeDetailMemberRepo())
    }
    
    func makeListAddressVM() -> ListAddressVM {
        return ListAddressVM(repository: makeListAddressRepo())
    }
    
    func makeAddAddressVM() -> AddAddressVM {
        return AddAddressVM(repository: makeAddAddressRepo())
    }
    
    func makeEditAddressVM() -> EditAddressVM {
        return EditAddressVM(repository: makeEditAddressRepo())
    }
    
}
