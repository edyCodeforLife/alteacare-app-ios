//
//  BookingCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class BookingCoordinator: BaseCoordinator, BookingCoordinatorOutput, DashboardCoordinatorOutput {
    var goToDoctorSpecialist: (() -> Void)?
    var goToCancelledConsultation: (() -> Void)?
    var goToCompleteConsults: (() -> Void)?
    var goToMyConsultation: (() -> Void)?
    var gotoMyConsultation: (() -> Void)?
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)?
    var onEndConsultations: (() -> Void)?
    var onAuthFlow: (() -> Void)?
    var onEndBooking: (() -> Void)?
    var goToDashboard: (() -> Void)?
    var onEndConsultation: (() -> Void)?
    
    private let router: Router
    private let factory: BookingFactory
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: BookingFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(booking with: BookingModeEntry) {
        switch with {
        case .listDoctorSpecialization(let idSpecialist, let nameSpecialist, let isSearch, let inputSearch, _):
            self.showListDoctor(id: idSpecialist, nameSpecialist: nameSpecialist, isRoot: true, isSearch: isSearch, inputSearch: inputSearch, isHiddenChipsbar: nameSpecialist.isEmpty ? true : false)
        case .listSpecialization:
            self.showListSpecialist(query: "", isShowBackButton: false)
        case .detailDoctor(let id, let isFromListDoctor):
            self.showDetailDoctor(id: id, isFromListDoctor: isFromListDoctor, selectedDayName: nil)
        case .searchAutocomplete:
            self.showSearchAutocomplete() //
        }
    }
    
    override func start() {
        showListSpecialist(query: "", isShowBackButton: false)
    }
    
    private func showListSpecialist(query: String, isShowBackButton: Bool) {
        let view = factory.makeListSpecialist(query: query, isShowBackButton: isShowBackButton)
        view.onSpecialistTapped = { [weak self] (id, name) in
            guard let self = self else { return }
            self.runConsultationFlow1(entry: .listDoctorSpecialization(idSpecialist: id, nameSpecialist: name, isSearch: false, inputSearch: "", isRoot: true))
        }
        view.onBackButtonPressed = {
            self.router.popModule()
        }
        if isShowBackButton {
            router.push(view, animated: true, hideBar: true, hideBottomBar: false, completion: nil)
        }else {
            router.setRootModule(view, hideBar: false)
        }
    }
    
    private func showListDoctor(id: String, nameSpecialist: String, isRoot: Bool = false, isSearch: Bool, inputSearch: String, isBackPrevPage: Bool = false, isHiddenChipsbar: Bool = true, patientData: MemberModel? = nil) {
        let view = factory.makeListDoctor()
        view.idSpecialist = id
        view.nameSpecialist = nameSpecialist
        view.isSearch = isSearch
        view.inputSearch = inputSearch
        view.isBackToPreviousPage = isBackPrevPage
        view.isHiddenChipsbar = isHiddenChipsbar
        view.onShowFilterTapped = { [weak self] (daysData, specializationsData, hospitalsData, doctorsData, pricesData, daySelected, tagSelected) in
            guard let self = self else { return }
            self.showFilterView(
                daysData: daysData,
                specializationsData: specializationsData,
                hospitalsData: hospitalsData,
                doctorsData: doctorsData,
                pricesData: pricesData,
                daySelected: daySelected,
                tagSelected: tagSelected,
                
                reloadListDoctor: { (dayTag, dataTag) in
                    view.onSubmitFilter(dayTag: dayTag, dataTag: dataTag)
                },
                onShowFindFilterView: { (typeFilter, dayTagFilter, dataTagFilter) in
                    self.showFindFilterView(
                        typeFilter: typeFilter,
                        dayTag: dayTagFilter,
                        currentTag: dataTagFilter,
                        specializations: specializationsData,
                        hospitals: hospitalsData,
                        doctors: doctorsData,
                        
                        onSubmitTapped: { (resultDayFind, resultDataFind) in
                            view.onSubmitFindFilter(dayTag: resultDayFind, dataTag: resultDataFind)
                        },
                        
                        onDismissTapped: {
                            view.onDismissFindFilter(dayTag: dayTagFilter, dataTag: dataTagFilter)
                        })
                    
                })
        }
        view.backPreviousPage = {
            self.router.popModule(animated: true)
        }
        
        view.onDoctorTapped = { [weak self] (id, isFromListDoctor, selectedDayName) in
            guard let self = self else { return }
            if let patientData = patientData {
                self.showDetailDoctor(id: id, isFromListDoctor: true, patient: patientData)
            } else {
                self.showDetailDoctor(id: id, isFromListDoctor: true, selectedDayName: selectedDayName)
            }
        }
        
        if isRoot {
            router.setRootModule(view, hideBar: true)
        } else {
            router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
        }
    }
    
    private func showFilterView(daysData: [DayName], specializationsData: [ListSpecialistModel], hospitalsData: [ListHospitalModel], doctorsData: [ListDoctorModel], pricesData: [ListPrice], daySelected: FilterList, tagSelected: [FilterList], reloadListDoctor: @escaping (FilterList, [FilterList]) -> Void, onShowFindFilterView: @escaping (TypeTagCollection, FilterList, [FilterList]) -> Void) {
        let view = factory.makeFilterDoctorView()
        view.daysData = daysData
        view.specializationsData = specializationsData
        view.hospitalsData = hospitalsData
        view.doctorsData = doctorsData
        view.pricesData = pricesData
        view.daySelected = daySelected
        view.tagSelected = tagSelected
        view.onShowAllTapped = { [weak self] (typeFilter, dayTag, dataTag) in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                onShowFindFilterView(typeFilter, dayTag, dataTag)
            }
        }
        view.onFilterTapped = { [ weak self] (dayTag, dataTag) in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                reloadListDoctor(dayTag, dataTag)
            }
        }
        router.present(view, mode: .basic)
    }
    
    private func showFindFilterView(typeFilter: TypeTagCollection, dayTag: FilterList, currentTag: [FilterList], specializations: [ListSpecialistModel], hospitals: [ListHospitalModel], doctors: [ListDoctorModel], onSubmitTapped: @escaping (FilterList, [FilterList]) -> Void, onDismissTapped: @escaping () -> Void) {
        let view = factory.makeFindFilterView()
        view.typeSelected = typeFilter
        view.daySelected = dayTag
        view.tagSelected = currentTag
        view.specializations = specializations
        view.hospitals = hospitals
        view.doctors = doctors
        view.onCloseView = {
            self.router.dismissModule(animated: true) {
                onDismissTapped()
            }
        }
        view.onFindFilterTapped = { [ weak self] (onDayTag, onDataTag) in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                onSubmitTapped(onDayTag, onDataTag)
            }
        }
        
        router.present(view, mode: .basic)
    }
    
    private func showListDoctor(idSpecialis: String, patientData: MemberModel){
        let view = factory.makeListDoctor()
        view.idSpecialist = idSpecialis
        view.isSearch = true
        view.inputSearch = ""
        view.isBackToPreviousPage = true
        
        view.backPreviousPage = {
            self.router.popModule(animated: true)
        }
        
        view.onDoctorTapped = { [weak self] (id, isFromListDoctor, selectedDayName) in
            guard let self = self else { return }
            self.showDetailDoctor(id: id, isFromListDoctor: true,patient: patientData)
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showDetailDoctor(id: String, isFromListDoctor: Bool,selectedDayName: DayName?) {
        let view = factory.makeDetailDoctor()
        view.isFormListDoctor = isFromListDoctor
        view.idDoctor = id
        view.selectedDayName = selectedDayName
        view.onDatetimeTapped = { [weak self] (dataSchedule, dataDoctor) in
            guard let self = self else { return }
            self.runFamilyFlow(entry: .readFamily) { (patient) in
                self.showCreateBooking(dataSchedule: dataSchedule, dataDoctor: dataDoctor, patientData: patient)
            }
            self.runFamilyFlow(entry: .addMember)
        }
        
        view.goToLogin = { [weak self] (photoDoctor, nameDoctor) in
            guard let self = self else { return }
            self.showLoginWith(photoDoctor: photoDoctor, nameDoctor: nameDoctor)
        }
        
        view.goToAddFamilyMember = { [weak self] in
            //Add family member
        }
        
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showLoginWith(photoDoctor: String, nameDoctor: String) {
        var coordinator = coordinatorFactory.makeAuthCoordinator(router: self.router)
        coordinator.onMenubarFlow = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(auth: .login(photoDoctor: photoDoctor, doctorName: nameDoctor))
    }
    
    private func showDetailDoctor(id: String, isFromListDoctor: Bool, patient: MemberModel) {
        let view = factory.makeDetailDoctor()
        view.isFormListDoctor = isFromListDoctor
        view.idDoctor = id
        view.onDatetimeTapped = { [weak self] (dataSchedule, dataDoctor) in
            guard let self = self else { return }
            self.showCreateBooking(dataSchedule: dataSchedule, dataDoctor: dataDoctor, patientData: patient)
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    
    private func showCreateBooking(dataSchedule: DoctorScheduleDataModel, dataDoctor: DetailDoctorModel, patientData: MemberModel) {
        let view = factory.makeCreateBooking()
        view.dataDateTimeSelected = dataSchedule
        view.dataDoctor = dataDoctor
        view.patientData = PatientBookingModel(id: patientData.idMember,
                                               namePatient: patientData.name,
                                               agePatient: patientData.age,
                                               dateOfBirthPatient: patientData.birthDate,
                                               genderPatient: patientData.gender,
                                               email: patientData.email,
                                               phone: patientData.phone
        )
        view.onCreated = { [weak self] (data, dataPatient) in
            guard let self = self else { return }
            self.showReviewBooking(dataBooking: data!, dataPatient: dataPatient!)
        }
        view.changeDoctorTapped = { [weak self] in
            guard let self = self else { return }
            if let viewControllers = view.toPresent()?.navigationController?.viewControllers {
                for viewController in viewControllers where viewController is ListDoctorVC {
                    self.router.popToModule(viewController, animated: true)
                    return
                }
            }
            self.showListDoctor(id: dataDoctor.idSpecialization ?? "", nameSpecialist: dataDoctor.specialization ?? "", isSearch: true,
                                inputSearch: "", isBackPrevPage: true, patientData: patientData)
        }
        
        view.changePatientDataTapped = { [weak self] (photoDoctor, nameDoctor)
            in
        }
        
        view.goToAddFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.runFamilyFlow(entry: .readFamily) { (patient) in
                view.patientData = PatientBookingModel(id: patient.idMember,
                                                       namePatient: patient.name,
                                                       agePatient: patient.age,
                                                       dateOfBirthPatient: patient.birthDate,
                                                       genderPatient: patient.gender,
                                                       email: patient.email,
                                                       phone: patient.phone
                )
            }
        }
        
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showReviewBooking(dataBooking: CreateBookingModel, dataPatient : PatientBookingModel) {
        let view = factory.makeReviewBooking()
        view.dataCreateBooking = dataBooking
        view.patientData = dataPatient
        view.onReviewed = { [weak self] (data, dataPatient) in
            guard let self = self else { return }
            self.showDrawerCallBooking(dataBooking: data!, dataPatient: dataPatient!)
        }
        view.changeDataPatientTapped = { [weak self] (photoDoctor, nameDoctor)
            in
            guard let self = self else { return }
            self.runFamilyFlow(entry: .readFamily) { (patient) in
                view.patientData = PatientBookingModel(id: patient.idMember,
                                                       namePatient: patient.name,
                                                       agePatient: patient.age,
                                                       dateOfBirthPatient: patient.birthDate,
                                                       genderPatient: patient.gender,
                                                       email: patient.email,
                                                       phone: patient.phone
                )
            }
        }
        
        view.goToAddFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.runFamilyFlow(entry: .addMember)
        }
        
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showDrawerCallBooking(dataBooking: CreateBookingModel, dataPatient : PatientBookingModel){
        let view = factory.makeDrawerCallBookingView()
        view.dataCreateBooking = dataBooking
        view.patientData = dataPatient
        
        view.goConnect = { [weak self] (id, orderCode, callMA) in
            guard let self = self else { return }
            self.router.dismissModule()
            self.runConsultationFlow(id: id, orderCode: orderCode, callMA: callMA)
        }
        
        view.onOutsideOperatingHour = { setting in
            self.router.dismissModule()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showOutsideOperatingHour(setting: setting) {}
            }
        }
        router.present(view, mode: .basic)
    }
    
    private func showOutsideOperatingHour(setting: SettingModel, gotoMyConsultation: @escaping ()->Void){
        let view = factory.makeOutsideOperatingHourViewBooking(setting: setting)
        view.onOkPressed = {
            self.router.dismissPanModal()
            self.gotoMyConsultation?()
        }
        self.router.pushPanModal(view)
    }
    
    private func showSearchAutocomplete() {
        let view = factory.makeSearchAutocomplete()
        view.onDoctorTapped = { [weak self] (id) in
            guard let self = self else { return }
            self.showDetailDoctor(id: id, isFromListDoctor: true, selectedDayName: nil)
        }
        view.onSymtomTapped = { [weak self] symptomName in
            guard let self = self else { return }
            self.showListDoctor(id: "", nameSpecialist: "", isRoot: false, isSearch: true, inputSearch: symptomName, isBackPrevPage: true, isHiddenChipsbar: true)
        }
        view.onSpecializationTapped = { [weak self] id, query, inputSearch in
            guard let self = self else { return }
            self.showListDoctor(id: id, nameSpecialist: query, isRoot: false, isSearch: false, inputSearch: "", isBackPrevPage: true, isHiddenChipsbar: false)
        }
        view.onSeeMoreDoctorTapped = { [weak self] (searchResult) in
            guard let self = self else { return }
            self.showListDoctor(id: "", nameSpecialist: "", isRoot: false, isSearch: true, inputSearch: searchResult, isBackPrevPage: true, isHiddenChipsbar: true)
        }
        view.onSeeMoreSymtomTapped = { [weak self] (searchResult) in
            self?.showSearchResult(searchResult, searchType: .symtom)
        }
        view.onSeeMoreSpecializationTapped = { [weak self] (searchResult) in
            self?.showListSpecialist(query: searchResult, isShowBackButton: true)
        }
        router.setRootModule(view, hideBar: true)
    }
    
    private func showSearchResult(_ query: String, searchType: search){
        let view = factory.makeListSymtomView(query: query,searchType: searchType)
        view.onSymtomTapped = { symtom in
            self.showListDoctor(id: "", nameSpecialist: "", isRoot: false, isSearch: true, inputSearch: symtom.title, isBackPrevPage: true, isHiddenChipsbar: true)
        }
        router.push(view, animated: true, hideBar: false, hideBottomBar: false, completion: nil)
    }
    
    private func runConsultationFlow(id: Int, orderCode: String?, callMA: Bool) {
        var (coordinator, module) = coordinatorFactory.makeConsultationCoordinator()
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.onEndBooking?()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onEndBooking"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.onEndBooking?()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "goToDashboard"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        coordinator.onCancelConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.onEndBooking?()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onCancelConsultation"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        addDependency(coordinator)
        router.present(module)
        coordinator.start(consultation: .initialScreening(id, orderCode, callMA))
    }
    
    private func runConsultationFlow1(entry: BookingModeEntry) {
        var (coordinator, module) = coordinatorFactory.makeBookingCoordinator()
        coordinator.onEndBooking = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.removeDependency(coordinator)
            }
        }
        coordinator.gotoMyConsultation = {
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.removeDependency(coordinator)
                self.gotoMyConsultation?()
            }
        }
        addDependency(coordinator)
        router.present(module)
        coordinator.start(booking: entry)
    }
    
    private func runFamilyFlow(entry: FamilyModeEntry, completion: ((MemberModel) -> Void)? = nil) {
        var (coordinator, module) = coordinatorFactory.makeFamilyCoordinator()
        coordinator.onSelectedMember = { [weak self] (patientId) in
            guard let self = self else { return }
            completion?(patientId)
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        coordinator.onCreatedMember = { [weak self] in
            guard let self = self else { return }
            
        }
        addDependency(coordinator)
        router.present(module, mode: .basic)
        coordinator.start(family: entry)
    }
    
}
