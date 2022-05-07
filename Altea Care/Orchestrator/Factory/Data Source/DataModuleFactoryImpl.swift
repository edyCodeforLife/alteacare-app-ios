//
//  DataModuleFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

class ModuleFactoryImpl: DataModuleFactory {
    func makeDetailAppointmentAPI() -> DetailAppointmentAPI {
        return DetailAppointmentAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeSendMessageAPI() -> SendMessageAPI {
        return SendMessageAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGetMessageTypeAPI() -> GetMessageTypeAPI {
        return GetMessageAPIImpl(httpClient: makeHTTPClient())
    }
    
    //MARK: - Base Identifier
    func makeBaseIdentifier() -> HTTPIdentifier {
        return BaseIdentifier()
    }
    
    func makeHTTPClient() -> HTTPClient {
        return HTTPClientImpl(identifier: makeBaseIdentifier())
    }
    
    //MARK: - Authentication
    func makeChangePasswordAPI() -> ChangePasswordApi {
        return ChangePasswordApiImpl(httpClient: makeHTTPClient())
    }
    
    func makeVerifyOtpFPAPI() -> VerifyOtpFPApi {
        return VerifyOtpApiImpl(httpClient: makeHTTPClient())
    }
    
    func makeRequestForgotPasswordAPI() -> RequestForgotPasswordAPI {
        return RequestForgotPasswordAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeVerifyEmailRegister() -> VerifyEmailAPI {
        return VerifyEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRegistrationChangeEmail() -> RegistrationChangeEmailAPI {
        return RegistrationChangeEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeLogout() -> LogoutAPI {
        return LogoutAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRegisterAPI() -> RegisterAPI {
        return RegisterAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeCountryAPI() -> CountryAPI {
        return CountryAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGenerateAppToken() -> AppTokenAPI {
        return AppTokenAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGenerateRefreshToken() -> RefreshTokenAPI {
        return RefreshTokenAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeLoginAPI() -> LoginAPI {
        return LoginAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeVerifyEmailAPI() -> VerifyEmailAPI {
        return VerifyEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeSendVerificationEmailAPI() -> SendVerificationEmailAPI {
        return SendVerificationEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRegistrationChangeEmailAPI() -> RegistrationChangeEmailAPI {
        return RegistrationChangeEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeLogoutAPI() -> LogoutAPI{
        return LogoutAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeCheckEmailRegisterAPI() -> CheckEmailRegisterAPI {
        return CheckEmailRegisterAPIImpl(httpClient: makeHTTPClient())
    }
    
    //MARK: - Booking
    func makeListConsultationAPI() -> ListConsultationAPI {
        return ListConsultationAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDetailConsultationAPI() -> DetailConsultationAPI {
        return DetailConsultationAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makePatientDataAPI() -> PatientDataAPI {
        return PatientDataAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeUploadDocumentAPI() -> UploadDocumentAPI {
        return UploadDocumentAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeBindDocumentAPI() -> BindDocumentAPI {
        return BindDocumentAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRemoveDocumentAPI() -> RemoveDocumentAPI {
        return RemoveDocumentAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeMedicalResumeAPI() -> MedicalResumeAPI {
        return MedicalResumeAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeMedicalDocumentAPI() -> MedicalDocumentAPI {
        return MedicalDocumentAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeReceiptConsultationAPI() -> ReceiptConsultationAPI {
        return ReceiptConsultationAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeChatHistoryAPI() -> ChatHistoryAPI {
        return ChatHistoryAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGenerateVideoTokenAPI() -> VideoTokenAPI {
        return VideoTokenAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeConsultationReviewAPI() -> ConsultationReviewAPI {
        return ConsultationReviewAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeScreeningReviewAPI() -> ScreeningReviewAPI {
        return ScreeningReviewAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makePaymentInquiryAPI() -> PaymentInquiryAPI {
        return PaymentInquiryAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makePaymentMethodAPI() -> PaymentMethodAPI {
        return PaymentMethodAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeVoucherAPI() -> VoucherAPI {
        return VoucherAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makePayConsultationAPI() -> PayConsultationAPI {
        return PayConsultationAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeListDoctorAPI() -> ListDoctorAPI {
        return ListDoctorAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeListSpecialistAPI() -> ListSpecialistAPI {
        return ListSpecialistAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeCreateConsultationAPI() -> CreateConsultationAPI {
        return CreateConsultationAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDoctorDetailsAPI() -> DoctorDetailsAPI {
        return DoctorDetailsAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDoctorScheduleAPI() -> DoctorScheduleAPI {
        return DoctorScheduleAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeTermRefundCancelAPI() -> TermRefundCancelAPI {
        return TermRefundCancelAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeSearchAPI() -> SearchAPI {
        return SearchAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeBannerAPI() -> DataBannerAPI {
        return DataBannerAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeListSymptomAPI() -> ListSymptomAPI {
        return ListSymptomAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeSettingAPI() -> SettingAPI {
        return SettingAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeUserCancelAPI() -> UserCancelAPI {
        return UserCancelAPIImpl(httpClient: makeHTTPClient())
    }
    
    //MARK: - Account
    func makeGetUserDataAPI() -> GetUserAPI {
        return GetUserAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeUpdateAvatarAPI() -> UpdateAvatarAPI {
        return UpdateAvatarAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeTermConditionAPI() -> TermConditionAPI {
        return TermConditionAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeCheckOldPassword() -> CheckOldPasswordAPI {
        return CheckOldPasswordAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeSendVerificationPhoneNumberAPI() -> SendVerificationPhoneNumberAPI {
        return SendVerificationPhoneNumberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeChangePhoneNumberAPI() -> ChangePhoneNumberAPI {
        return ChangePhoneNumberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeVerifyPhoneNumberAPI() -> VerifyPhoneNumberAPI {
        return VerifyPhoneNumberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRequestChangePhoneNumberAPI() -> RequestChangePhoneNumberAPI {
        return RequestChangePhoneNumberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeFaqsAPI() -> FaqsAPI {
        return FaqsAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeChangeEmailAPI() -> RequestChangeEmailAPI {
        return RequestChangeEmailAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeVerifyChangeEmailAPI() -> ChangeEmailVerifyAPI {
        return ChangeEmailVerifyAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeInformationCenterAPI() -> InformationCenterAPI {
        return InformationCenterAPIImpl(httpClient: makeHTTPClient())
    }
    
    //MARK: - Family & Address
    func makeListMemberAPI() -> ListMemberAPI {
        return ListMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeAddMemberAPI() -> AddMemberAPI {
        return AddMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeFamilyRelationAPI() -> FamilyRelationAPI {
        return FamilyRelationAPIImpl(httpClient: makeHTTPClient())
    }
    
    
    func makeUpdateMemberAPI() -> UpdateMemberAPI {
        return UpdateMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDeleteMemberAPI() -> DeleteMemberAPI {
        return DeleteMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDetailMemberAPI() -> DetailMemberAPI {
        return DetailMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDefaultMemberAPI() -> DefaultMemberAPI {
        return DefaultMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    
    func makeListAddressAPI() -> ListAddressAPI {
        return ListAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeAddAddressAPI() -> AddAddressAPI {
        return AddAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeEditAddressAPI() -> EditAddressAPI {
        return EditAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDeleteAddressAPI() -> DeleteAddressAPI {
        return DeleteAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeDetailAddressAPI() -> DetailAddressAPI {
        return DetailAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makePrimaryAddressAPI() -> PrimaryAddressAPI {
        return PrimaryAddressAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGetProvinceAPI() -> ProvinciesAPI {
        return ProvinciesAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGetCityAPI() -> CitiesAPI {
        return CitiesAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGetDistrictAPI() -> DistrictAPI {
        return DistrictAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeGetSubDistrictAPI() -> SubDistrictAPI {
        return SubDistrictAPIImpl(httpClient: makeHTTPClient())
    }
    
    func makeRegisterMemberAPI() -> RegisterMemberAPI {
        return RegisterMemberAPIImpl(httpClient: makeHTTPClient())
    }
    
    //MARK: - Force Update
    
    func makeForceUpdateAPI() -> ForceUpdateAPI {
        return ForceUpdateAPIImpl(httpClient: makeHTTPClient())
    }
    
    // MARK: - List Hospital
    
    func makeListHospitalAPI() -> ListHospitalAPI {
        return ListHospitalAPIImpl(httpClient: makeHTTPClient())
    }
    //MARK: - Widget
    func makeWidgetAPI() -> WidgetAPI {
        return WidgetAPIImpl(httpClient: makeHTTPClient())
    }
}
