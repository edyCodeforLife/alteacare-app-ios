//
//  DataModuleFactory.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

protocol DataModuleFactory {
    // MARK: - HTTP Client
    func makeBaseIdentifier() -> HTTPIdentifier
    func makeHTTPClient() -> HTTPClient
    
    // MARK: - API
    func makeGenerateAppToken() -> AppTokenAPI
    func makeGenerateRefreshToken() -> RefreshTokenAPI
    
    //MARK: - Auth API
    func makeLoginAPI() -> LoginAPI
    func makeRegisterAPI() -> RegisterAPI
    func makeTermConditionAPI() -> TermConditionAPI
    func makeTermRefundCancelAPI
    () -> TermRefundCancelAPI
    func makeChangePasswordAPI() -> ChangePasswordApi
    func makeVerifyOtpFPAPI() -> VerifyOtpFPApi
    func makeRequestForgotPasswordAPI() -> RequestForgotPasswordAPI
    func makeVerifyEmailRegister() -> VerifyEmailAPI
    func makeSendVerificationEmailAPI() -> SendVerificationEmailAPI
    func makeRegistrationChangeEmail() -> RegistrationChangeEmailAPI
    func makeCheckEmailRegisterAPI() -> CheckEmailRegisterAPI
    
    //MARK: - Booking API
    func makeListConsultationAPI() -> ListConsultationAPI
    func makeDetailConsultationAPI() -> DetailConsultationAPI
    func makePatientDataAPI() -> PatientDataAPI
    func makeUploadDocumentAPI() -> UploadDocumentAPI
    func makeBindDocumentAPI() -> BindDocumentAPI
    func makeRemoveDocumentAPI() -> RemoveDocumentAPI
    func makeMedicalResumeAPI() -> MedicalResumeAPI
    func makeMedicalDocumentAPI() -> MedicalDocumentAPI
    func makeReceiptConsultationAPI() -> ReceiptConsultationAPI
    func makeChatHistoryAPI() -> ChatHistoryAPI
    func makeGenerateVideoTokenAPI() -> VideoTokenAPI
    func makeConsultationReviewAPI() -> ConsultationReviewAPI
    func makeScreeningReviewAPI() -> ScreeningReviewAPI
    func makePaymentInquiryAPI() -> PaymentInquiryAPI
    func makeListDoctorAPI() -> ListDoctorAPI
    func makeListSpecialistAPI() -> ListSpecialistAPI
    func makeCreateConsultationAPI() -> CreateConsultationAPI
    func makeSearchAPI() -> SearchAPI
    func makeDetailAppointmentAPI() -> DetailAppointmentAPI
    func makeVoucherAPI() -> VoucherAPI
    func makeListSymptomAPI() -> ListSymptomAPI
    func makeSettingAPI() -> SettingAPI
    func makeUserCancelAPI() -> UserCancelAPI
    
    //MARK: - API Account
    func makeGetUserDataAPI() -> GetUserAPI
    func makeLogoutAPI() -> LogoutAPI
    func makeCheckOldPassword() -> CheckOldPasswordAPI
    func makeSendVerificationPhoneNumberAPI() -> SendVerificationPhoneNumberAPI
    func makeChangePhoneNumberAPI() -> ChangePhoneNumberAPI
    func makeVerifyPhoneNumberAPI() -> VerifyPhoneNumberAPI
    func makeRequestChangePhoneNumberAPI() -> RequestChangePhoneNumberAPI
    func makeFaqsAPI() -> FaqsAPI
    func makeChangeEmailAPI() -> RequestChangeEmailAPI
    func makeVerifyChangeEmailAPI() -> ChangeEmailVerifyAPI
    func makeInformationCenterAPI() -> InformationCenterAPI
    
    //MARK: - Logout API
    func makeLogout() -> LogoutAPI
    func makePaymentMethodAPI() -> PaymentMethodAPI
    func makeDoctorDetailsAPI() -> DoctorDetailsAPI
    func makeDoctorScheduleAPI() -> DoctorScheduleAPI
    
    func makeSendMessageAPI() -> SendMessageAPI
    func makeGetMessageTypeAPI() -> GetMessageTypeAPI
    
    //MARK: -Banner API
    func makeBannerAPI() -> DataBannerAPI
    
    //MARK: - Family & Address
    func makeListMemberAPI() -> ListMemberAPI
    func makeAddMemberAPI() -> AddMemberAPI
    func makeUpdateMemberAPI() -> UpdateMemberAPI
    func makeDeleteMemberAPI() -> DeleteMemberAPI
    func makeDetailMemberAPI() -> DetailMemberAPI
    func makeDefaultMemberAPI() -> DefaultMemberAPI
    func makeListAddressAPI() -> ListAddressAPI
    func makeAddAddressAPI() -> AddAddressAPI
    func makeEditAddressAPI() -> EditAddressAPI
    func makeDeleteAddressAPI() -> DeleteAddressAPI
    func makeDetailAddressAPI() -> DetailAddressAPI
    func makePrimaryAddressAPI() -> PrimaryAddressAPI
    func makeGetProvinceAPI() -> ProvinciesAPI
    func makeGetCityAPI() -> CitiesAPI
    func makeGetDistrictAPI() -> DistrictAPI
    func makeGetSubDistrictAPI() -> SubDistrictAPI
    func makeRegisterMemberAPI() -> RegisterMemberAPI
    
    //MARK: - Force Update
    func makeForceUpdateAPI() -> ForceUpdateAPI
    
    //MARK: - Widget
    func makeWidgetAPI() -> WidgetAPI
}
