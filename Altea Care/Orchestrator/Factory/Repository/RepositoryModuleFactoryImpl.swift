//
//  RepositoryModuleFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

extension ModuleFactoryImpl: RepositoryModuleFactory {
    
    // MARK: - Auth
    func makeLoginRepo() -> LoginRepository {
        return LoginRepositoryImpl(loginApi: self.makeLoginAPI(), sendEmailOtpApi: self.makeSendVerificationEmailAPI())
    }
    
    func makeRegisterReviewRepo() -> RegisterReviewRepository {
        return RegisterReviewRepositoryImpl(api: self.makeRegisterAPI())
    }
    
    func makeContactFieldRepo() -> ContactFieldRepository {
        return ContactFieldRepositoryImpl(checkEmailRegisterAPI: self.makeCheckEmailRegisterAPI())
    }
    
    func makeCreatePasswordRepo() -> CreatePasswordRepository {
        return CreatePasswordImpl(api: self.makeRegisterAPI())
    }
    
    func makeRegisterRepo() -> RegisterRepository {
        return RegisterRepositoryImpl(countryAPI: self.makeCountryAPI())
    }
    
    func makeTermAndConditionRepo() -> TermAndConditionRepository {
        return TermAndConditionRepositoryImpl(apiRegister: self.makeRegisterAPI(), sendEmailOtp: self.makeSendVerificationEmailAPI(), termConditionAPI: self.makeTermConditionAPI())
    }
    
    func makeCreateNewPasswordRepo() -> CreateNewPasswordRepository {
        return CreateNewPasswordRepositoryImpl(api: self.makeChangePasswordAPI())
    }
    
    func makeChangeEmailAddressRepo() -> ChangeEmailAddressRepository {
        return ChangeEmailAddressRepositoryImpl(api: self.makeRegistrationChangeEmailAPI())
    }
    
    func makeEmailVerificationRepo() -> EmailVerificationRepository {
        return EmailVerificationRepositoryImpl(apiVerifyEmail: self.makeVerifyEmailAPI(), apiSendVerification: self.makeSendVerificationEmailAPI())
    }
    
    func makeInitialForgotPasswordRepo() -> ForgotPasswordRepository {
        return ForgotPasswordRepositoryImpl(api: self.makeRequestForgotPasswordAPI())
    }
    
    func makeReverificationEmailRepo() -> ReverificationEmailRepository {
        return ReverificationEmailRepositoryImpl(verifyEmailForgotPasswordAPI: self.makeVerifyOtpFPAPI(), requestNewOtpForgotPasswordAPI: self.makeRequestForgotPasswordAPI())
    }
    
    func makeSuccessRegisterRepo() -> SuccessRegisterRepository {
        return SuccessRegisterRepositoryImpl(getUserAPI: makeGetUserDataAPI())
    }
    
    func makeSwitchAccountRepo() -> SwitchAccountRepository {
        return SwitchAccountRepositoryImpl()
    }
    
    // MARK: - Dashboard
    func makeHomeRepo() -> HomeRepository {
        return HomeRepositoryImpl(listSpecialistAPI: self.makeListSpecialistAPI(), getUserAPI: self.makeGetUserDataAPI(), listConsultationAPI: self.makeListConsultationAPI(), dataBannerAPI: self.makeBannerAPI(), listMemberAPI: self.makeListMemberAPI(), forceUpdateAPI: self.makeForceUpdateAPI(), widgetAPI: makeWidgetAPI())
    }
    
    func makeForceUpdateRepo() -> ForceUpdateRepository {
        return ForceUpdateRepositoryImpl(forceUpdateAPI: makeForceUpdateAPI())
    }
        
    func makeListHospitalRepo() -> FilterListHospitalRepository {
        return FilterListHospitalRepositoryImpl(listHospitalAPI: self.makeListHospitalAPI())
    }
    
    // MARK: - Booking
    func makeListSpecialistRepo() -> ListSpecialistRepository {
        return ListSpecialistRepositoryImpl(api: self.makeListSpecialistAPI())
    }
    
    func makeListDoctorRepo() -> ListDoctorRepository {
        return ListDoctorRepositoryImpl(api: self.makeListDoctorAPI(), apiSearch: self.makeSearchAPI())
    }
    
    func makeDetailDoctorRepo() -> DetailDoctorRepository {
        return DetailDoctorRepositoryImpl(doctorDetailsAPI: makeDoctorDetailsAPI(), doctorSheduleAPI: makeDoctorScheduleAPI(), termRefundCancelAPI: makeTermRefundCancelAPI())
    }
    
    func makeCreateBookingRepo() -> CreateBookingRepository {
        return CreateBookingRepositoryImpl(api: self.makeDetailConsultationAPI())
    }
    
    func makeReviewBookingRepo() -> ReviewBookingRepository {
        return ReviewBookingRepositoryImpl(createBookingApi: self.makeCreateConsultationAPI())
    }
    
    func makeSearchEverythingRepo() -> SearchAutocompleteRepository {
        return SearchAutocompleteRepositoryImpl(api: self.makeSearchAPI())
    }
    
    func makeDrawerCallBookingRepo() -> DrawerCallBookingRepository {
        return DrawerCallBookingRepositoryImpl(createBookingAPI: self.makeCreateConsultationAPI())
    }
    
    func makeSearchResultRepo() -> SymtomRepository {
        return SymtomRepositoryImpl(listSpecialistApi: self.makeListSpecialistAPI(), listSymptomAPI: self.makeListSymptomAPI())
    }
    
    // MARK: - Consultation
    func makeInitialScreeningRepo() -> InitialScreeningRepository {
        return InitialScreeningRepositoryImpl(videoTokenAPI: makeGenerateVideoTokenAPI(), patientDataAPI: makePatientDataAPI(), settingAPI: makeSettingAPI())
    }
    
    func makeReviewScreeningRepo() -> ReviewScreeningRepository {
        return ReviewScreeningRepositoryImpl(screeningReviewAPI: makeScreeningReviewAPI(), consultationReviewAPI: makeConsultationReviewAPI(), patientDataAPI: makePatientDataAPI())
    }
    
    func makeOngogingConsultationRepo() -> OngoingConsultationRepository {
        return OngoingConsultationRepositoryImpl(listMemberAPI: makeListMemberAPI(), listConsultationAPI: makeListConsultationAPI(), detailConsultationAPI: makeDetailConsultationAPI())
    }
    
    func makeHistoryConsultationRepo() -> HistoryConsultationRepository {
        return HistoryConsultationRepositoryImpl(listConsultationAPI: makeListConsultationAPI(), detailConsultationAPI: makeDetailConsultationAPI(), listMemberAPI: makeListMemberAPI())
    }
    
    func makeCancelConsultationRepo() -> CancelConsultationRepository {
        return CancelConsultationRepositoryImpl(listConsultationAPI: makeListConsultationAPI(), detailConsultationAPI: makeDetailConsultationAPI(),listMemberAPI: makeListMemberAPI())
    }
    
    func makeChatHistoryRepo() -> ChatHistoryRepository {
        return ChatHistoryRepositoryImpl(chatHistoryAPI: makeChatHistoryAPI())
    }
    
    func makePatientDataRepo() -> PatientDataRepository {
        return PatientDataRepositoryImpl(patientDataAPI: makePatientDataAPI(), uploadDocumentAPI: makeUploadDocumentAPI(), bindDocumentAPI: makeBindDocumentAPI(), removeDocumentAPI: makeRemoveDocumentAPI())
    }
    
    func makeMedicalResumeRepo() -> MedicalResumeRepository {
        return MedicalResumeRepositoryImpl(medicalResumeAPI: makeMedicalResumeAPI())
    }
    
    func makeMedicalDocumentRepo() -> MedicalDocumentRepository {
        return MedicalDocumentRepositoryImpl(medicalDocumentAPI: makeMedicalDocumentAPI())
    }
    
    func makeReceiptRepo() -> ReceiptRepository {
        return ReceiptRepositoryImpl(receiptConsultationAPI: makeReceiptConsultationAPI())
    }
    
    func makeLoginOtherPatientRepo() -> LoginConsulatationRepository {
        return LoginConsultationRepositoryImpl(loginApi: makeLoginAPI(), userApi: makeGetUserDataAPI(), logoutApi: makeLogout())
    }
    
    func makeSettingRepo() -> SettingRepository {
        return SettingRepoasitoryImpl(settingAPI: makeSettingAPI())
    }
    
    func makeRequestCanceRepo() -> RequestCancelRepository {
        return RequestCancelRepositoryImpl(userCancelAPI: makeUserCancelAPI())
    }
    
    // MARK: - Payment
    func makeInquiryPaymentRepo() -> InquiryPaymentRepository {
        return InquiryPaymentRepositoryImpl(paymentInquiryAPI: makePaymentInquiryAPI())
    }
    
    func makeReviewPaymentRepo() -> ReviewPaymentRepository {
        return ReviewPaymentRepositoryImpl(detailAppointmentAPI: makeDetailAppointmentAPI())
    }
    
    func makePaymentMethodRepo() -> PaymentMethodRepository {
        return PaymentMethodRepositotyImpl(paymentMethodAPI: makePaymentMethodAPI(), payConsultationAPI: makePayConsultationAPI())
    }
    
    func makeAlteaPaymentRepo() -> AlteaPaymentWebViewRepository {
        return AlteaPaymentWebViewRepositoryImpl(detailAppointmentAPI: makeDetailAppointmentAPI())
    }
    
    func makeConsulationExpiredRepo() -> ConsultationExpiredRepository {
        return ConsultationExpiredRepositoryImpl(detailAppointmentAPI: makeDetailAppointmentAPI())
    }
    
    func makeVoucherRepo() -> VoucherRepository {
        return VoucherRepositoryImpl(voucherAPI: makeVoucherAPI())
    }
    
    
    // MARK: - Account
    func makeAccountRepo() -> AccountRepository {
        return AccountRepositoryImpl(getUserAPI: makeGetUserDataAPI(), logoutAPI: makeLogoutAPI())
    }
    
    func makeInitialSetAccountRepo() -> InitialSetAccountRepository {
        return InitialSetAccountRepositoryImpl()
    }
    
    func makeOldPasswordRepo() -> OldPasswordRepository {
        return OldPasswordRepositoryImpl(checkOldPasswordAPI: makeCheckOldPassword())
    }
    
    func makeChangePasswordRepo() -> ChangePasswordRepository {
        return ChangePasswordRepositoryImpl(changePasswordAPI: makeChangePasswordAPI())
    }
    
    func makeTermConditionRepo() -> TermConditionRepository {
        return TermConditionRepositoryImpl(termConditionAPI: makeTermConditionAPI())
    }
    
    func makeContactUsRepo() -> ContactUsRepository {
        return ContactUsRepositoryImpl(sendMessageAPI: makeSendMessageAPI(), getMessageTypeAPI: makeGetMessageTypeAPI(), informationCenterAPI: makeInformationCenterAPI())
    }
    
    func makeFaqsRepo() -> FaqRepository {
        return FaqRepositoryImpl(faqAPI: makeFaqsAPI())
    }
    
    func makeChangePersonalDataRepo() -> ChangePersonalRepository {
        return ChangePersonalRepositoryImpl()
    }
    
    func makeInitialChangePhoneNumberRepo() -> InitialChangePhoneNumberRepository {
        return InitialChangePhoneNumberRepositoryImpl(changePhoneNumberAPI: makeRequestChangePhoneNumberAPI())
    }
    
    func makeVerifyPhoneNumberRepo() -> VerifyPhoneNumberRepository {
        return VerifyPhoneNumberRepositoryImpl(verifyPhoneNumberAPI: makeChangePhoneNumberAPI())
    }
    
    func makeInitialChangeProfileRepo() -> InitialChangeProfileRepository {
        return InitialChangeProfileRepositoryImpl(uploadImageAPI: makeUploadDocumentAPI(), getUserDataAPI: makeGetUserDataAPI(), updateAvatarAPI: makeUpdateAvatarAPI())
    }
    
    func makeChangeEmailRepo() -> ChangeEmailRepository {
        return ChangeEmailRepositoryImpl(changeEmailAPI: makeChangeEmailAPI())
    }
    
    func makeChangeEmailVerifyRepo() -> VerifyChangeEmailRepository {
        return VerifyChangeEmailRepositoryImpl(changeEmailVerifyAPI: makeVerifyChangeEmailAPI())
    }
    
    //MARK: - Family
    func makeListMemberRepo() -> ListMemberRepository {
        return ListMemberRepositoryImpl(listMemberAPI: makeListMemberAPI(), deleteMemberAPI: makeDeleteMemberAPI(), defaultMemberAPI: makeDefaultMemberAPI())
    }
    
    func makeAddMemberRepo() -> AddMemberRepository {
        return AddMemberRepositoryImpl(addMemberAPI: makeAddMemberAPI(), countryAPI: makeCountryAPI(), familyRelationAPI: makeFamilyRelationAPI())
    }
    
    func makeEditMemberRepo() -> EditMemberRepository {
        return EditMemberRepositoryImpl(detailMemberAPI: makeDetailMemberAPI(), updateMemberAPI: makeUpdateMemberAPI(), countryAPI: makeCountryAPI(), familyRelationAPI: makeFamilyRelationAPI())
    }
    
    func makeVerifyMemberRepo() -> VerifyMemberRepository {
        return VerifyMemberRepositoryImpl()
    }
    
    func makeRegisterMemberRepo() -> RegisterMemberRepository {
        return RegisterMemberRepositoryImpl(registerMemberAPI: makeRegisterMemberAPI(), addMemberAPI: makeAddMemberAPI())
    }
    
    func makePasswordMemberRepo() -> PasswordMemberRepository {
        return PasswordMemberRepositoryImpl()
    }
    
    func makeDetailMemberRepo() -> DetailMemberRepository {
        return DetailMemberRepositoryImpl(detailMemberAPI: makeDetailMemberAPI(), deleteMemberAPI: makeDeleteMemberAPI())
    }
    
    func makeListAddressRepo() -> ListAddressRepository {
        return ListAddressRepositoryImpl(listAddressAPI: makeListAddressAPI(), deleteAddressAPI: makeDeleteAddressAPI(), primaryAddressAPI: makePrimaryAddressAPI())
    }
    
    func makeAddAddressRepo() -> AddAddressRepository {
        return AddAddressRepositoryImpl(addAddressAPI: makeAddAddressAPI(), countryAPI: makeCountryAPI(), provinceAPI: makeGetProvinceAPI(), cityAPI: makeGetCityAPI(), districtAPI: makeGetDistrictAPI(), subdistrictAPI: makeGetSubDistrictAPI())
    }
    
    func makeEditAddressRepo() -> EditAddressRepository {
        return EditAddressRepositoryImpl(detailAddressAPI: makeDetailAddressAPI(), editAddressAPI: makeEditAddressAPI(), countryAPI: makeCountryAPI(), provinceAPI: makeGetProvinceAPI(), cityAPI: makeGetCityAPI(), districtAPI: makeGetDistrictAPI(), subdistrictAPI: makeGetSubDistrictAPI())
    }
}
