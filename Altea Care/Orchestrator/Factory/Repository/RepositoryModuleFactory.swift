//
//  RepositoryModuleFactory.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol RepositoryModuleFactory {
    // MARK: - Auth
    func makeLoginRepo() -> LoginRepository
    func makeRegisterRepo() -> RegisterRepository
    func makeRegisterReviewRepo() -> RegisterReviewRepository
    func makeContactFieldRepo() -> ContactFieldRepository
    func makeCreatePasswordRepo() -> CreatePasswordRepository
    func makeTermAndConditionRepo() -> TermAndConditionRepository
    func makeChangeEmailAddressRepo() -> ChangeEmailAddressRepository
    func makeEmailVerificationRepo() -> EmailVerificationRepository
    func makeSuccessRegisterRepo() -> SuccessRegisterRepository
    
    //MARK: - Forgot Password
    func makeInitialForgotPasswordRepo() -> ForgotPasswordRepository
    func makeReverificationEmailRepo() -> ReverificationEmailRepository
    func makeCreateNewPasswordRepo() -> CreateNewPasswordRepository
    
    // MARK: - Dashboard
    func makeHomeRepo() -> HomeRepository
    func makeForceUpdateRepo() -> ForceUpdateRepository
    
    // MARK: - Booking
    func makeListSpecialistRepo() -> ListSpecialistRepository
    func makeDetailDoctorRepo() -> DetailDoctorRepository
    func makeCreateBookingRepo() -> CreateBookingRepository
    func makeReviewBookingRepo() -> ReviewBookingRepository
    func makeSearchEverythingRepo() -> SearchAutocompleteRepository
    func makeLoginOtherPatientRepo() -> LoginConsulatationRepository
    func makeDrawerCallBookingRepo() -> DrawerCallBookingRepository
    func makeSearchResultRepo() -> SymtomRepository
    
    // MARK: - Consultation
    func makeInitialScreeningRepo() -> InitialScreeningRepository
    func makeReviewScreeningRepo() -> ReviewScreeningRepository
    func makeOngogingConsultationRepo() -> OngoingConsultationRepository
    func makeHistoryConsultationRepo() -> HistoryConsultationRepository
    func makeCancelConsultationRepo() -> CancelConsultationRepository
    func makeChatHistoryRepo() -> ChatHistoryRepository
    func makePatientDataRepo() -> PatientDataRepository
    func makeMedicalResumeRepo() -> MedicalResumeRepository
    func makeMedicalDocumentRepo() -> MedicalDocumentRepository
    func makeReceiptRepo() -> ReceiptRepository
    func makeConsulationExpiredRepo() -> ConsultationExpiredRepository
    func makeAlteaPaymentRepo() -> AlteaPaymentWebViewRepository
    func makeSettingRepo() -> SettingRepository
    func makeRequestCanceRepo() -> RequestCancelRepository
    
    // MARK: - Payment
    func makeInquiryPaymentRepo() -> InquiryPaymentRepository
    func makeReviewPaymentRepo() -> ReviewPaymentRepository
    func makePaymentMethodRepo() -> PaymentMethodRepository
    
    // MARK: - Account
    func makeAccountRepo() -> AccountRepository
    func makeTermConditionRepo() -> TermConditionRepository
    func makeContactUsRepo() -> ContactUsRepository
    func makeFaqsRepo() -> FaqRepository
    func makeChangePersonalDataRepo() -> ChangePersonalRepository
    func makeInitialChangePhoneNumberRepo() -> InitialChangePhoneNumberRepository
    func makeVerifyPhoneNumberRepo() -> VerifyPhoneNumberRepository
    func makeInitialChangeProfileRepo() -> InitialChangeProfileRepository
    func makeInitialSetAccountRepo() -> InitialSetAccountRepository
    func makeChangePasswordRepo() -> ChangePasswordRepository
    func makeOldPasswordRepo() -> OldPasswordRepository
    func makeChangeEmailRepo() -> ChangeEmailRepository
    func makeChangeEmailVerifyRepo() -> VerifyChangeEmailRepository
    
    //MARK: - ContactUs
    
    
    //MARK: - Family
    func makeListMemberRepo() -> ListMemberRepository
    func makeAddMemberRepo() -> AddMemberRepository
    func makeEditMemberRepo() -> EditMemberRepository
    func makeVerifyMemberRepo() -> VerifyMemberRepository
    func makeRegisterMemberRepo() -> RegisterMemberRepository
    func makePasswordMemberRepo() -> PasswordMemberRepository
    func makeDetailMemberRepo() -> DetailMemberRepository
    func makeListAddressRepo() -> ListAddressRepository
    func makeAddAddressRepo() -> AddAddressRepository
    func makeEditAddressRepo() -> EditAddressRepository
    
}
