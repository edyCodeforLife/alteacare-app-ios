//
//  HomeVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import FSPagerView
import AppTrackingTransparency
import PanModal
import MSPeekCollectionViewDelegateImplementation
import FBAudienceNetwork
import FBSDKCoreKit

class HomeVC: UIViewController, HomeView {
    var onPaymentMethodTapped: ((String) -> Void)?
    var onPaymentContinueTapped: ((String, Int) -> Void)?
    var onGoToDoctorSpecialist: (() -> Void)?
    var onOutsideOperatingHour: ((SettingModel) -> Void)?
    var onGoToForceUpdate: (() -> Void)?
    
    @IBOutlet weak var buttonVerification: ACButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ChangeAccountButton: ACButton!
    @IBOutlet weak var vSearch: CardView!
    @IBOutlet weak var cvSpesialist: UICollectionView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAgePoin: UILabel!
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbSubWelcome: UILabel!
    @IBOutlet weak var lbSearchTitle:UILabel!
    @IBOutlet weak var ivPhotoProfile: UIImageView!
    @IBOutlet weak var containerHomeView: UIView!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var btnSignIn: ButtonTemplate!
    @IBOutlet weak var vLogin: CardView!
    @IBOutlet weak var pvMyConsultation: FSPagerView!
    @IBOutlet weak var pcMyConsultation: FSPageControl!
    @IBOutlet weak var vMyConsultation: UIView!
    @IBOutlet weak var labelBanner: UILabel!
    @IBOutlet weak var bannerCv: UICollectionView!
    @IBOutlet weak var widgetCV: UICollectionView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var widgetHeight: NSLayoutConstraint!
    
    var onChangeAccount: (([UserCredential]) -> Void)?
    var onConsultationCallingTapped: ((Int, String?, Bool) -> Void)?
    var onConsultationTapped: ((String, ConsultationStatus) -> Void)?
    var onSignInTapped: (() -> Void)?
    var onSearchAutocomplete: (() -> Void)?
    var onGoToRegister: (() -> Void)?
    var onTappedListDoctor: (() -> Void)?
    var onTappedListDoctorSpecialization: ((String, String, Bool) -> Void)?
    var onGotoWebView: ((String, Bool) -> Void)?
    var userEmail : String!
    var viewModel: HomeVM!
    
    let gradientLayer = CAGradientLayer()
    let credentialData = CredentialManager.shared.getCredentials()
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let updateRelay = PublishRelay<Void>()
    private let userDataRelay =  BehaviorRelay<String?>(value: nil)
    private let modelUser : UserHomeData? = nil
    private var setting: SettingModel? {
        didSet {
            self.pvMyConsultation.reloadData()
        }
    }
    private var bannerData = [BannerModel]() {
        didSet {
            self.setupPager()
            self.bannerCv.reloadData()
        }
    }
    private var bannerTimer: Timer?
    private var currentBannerIndex = 0
    private var updateData : ForceUpdateModel? = nil
    private var modelListMember = [MemberModel]()
    private var errorUserData: Bool? {
        didSet {
            if let isErrorUserData = errorUserData, isErrorUserData {
                setupUI(nil)
            }
        }
    }
    private lazy var refreshControl = UIRefreshControl()
    
    let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
    let refreshToken = Preference.getString(forKey: .AccessRefreshTokenKey) ?? ""
    
    private var modelSpecialist = [ListSpecialistModel]() {
        didSet {
            self.cvSpesialist.reloadData()
        }
    }
    
    private var modelMyConsultation = [OngoingConsultationModel]() {
        didSet {
            self.pvMyConsultation.reloadData()
        }
    }
    
    private var widgets = [WidgetModel]() {
        didSet{
            if widgets.isEmpty {
                widgetHeight.constant = 0.0
            } else {
                widgetHeight.constant = 110.0
            }
            widgetCV.reloadData()
        }
    }
    
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"
    var behavior = MSCollectionViewPeekingBehavior(cellSpacing: 8, cellPeekWidth: 16)
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupCell()
        self.setupUI(modelUser)
        self.viewDidLoadRelay.accept(())
        self.updateRelay.accept(())
        self.userDataRelay.accept(.none)
        
        self.ChangeAccountButton.onTapped = {
            self.onChangeAccount?(self.credentialData)
        }
        
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        FBAdSettings.setAdvertiserTrackingEnabled(true)
                        Settings.isAutoLogAppEventsEnabled = true
                        Settings.isAdvertiserIDCollectionEnabled = true
                    case .denied, .restricted:
                        FBAdSettings.setAdvertiserTrackingEnabled(false)
                        Settings.isAutoLogAppEventsEnabled = false
                        Settings.isAdvertiserIDCollectionEnabled = false
                    case .notDetermined:
                        print("ATTrackingManager-notDetermined")
                    @unknown default:
                        print("ATTrackingManager-@unknown default")
                    }
                })
            }
        }
    }
    
    func setupPager(){
        pageControl.isEnabled = false
        pageControl.numberOfPages = bannerData.count
        if !bannerData.isEmpty {
            updatePageControlUI(currentPageIndex: pageControl.currentPage)
        }
    }
    
    func updatePageControlUI(currentPageIndex: Int) {
        pageControl.currentPage = currentPageIndex
        pageControl.pageIndicatorTintColor = .alteaDark3
        pageControl.currentPageIndicatorTintColor = .alteaDarker
        
        (0..<pageControl.numberOfPages).forEach { (index) in
            let activePageIconImage = UIImage(named: "SelectedPage")
            let otherPageIconImage = UIImage(named: "UnselectedPage")
            let pageIcon = index == currentPageIndex ? activePageIconImage : otherPageIconImage
            
            if #available(iOS 14.0, *) {
                pageControl.setIndicatorImage(pageIcon, forPage: index)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.viewDidLoadRelay.accept(())
        self.setupUI(modelUser)
        self.setupChangeUser(modelUser)
    }
    
    // MARK: - Binding ViewModel
    func bindViewModel() {
        let input = HomeVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), updateRelay: self.updateRelay.asObservable(), fetchUserData: userDataRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.state.drive { (_) in
            //            self.refreshControl.endRefreshing()
        }.disposed(by: self.disposeBag)
        output.specialistPopular.drive { (list) in
            self.modelSpecialist = list
        }.disposed(by: self.disposeBag)
        output.userData.drive { (model) in
            self.userEmail = model?.email
            self.setupChangeUser(model)
            self.setupUI(model)
            CredentialManager.shared.addUserCredential(UserCredential(id: model!.id, email: model!.email, accessToken: self.token, refreshToken: self.refreshToken, userName: model!.nameUser))
            self.defaultAnalyticsService.active(AnalyticsUserData(id: model?.id, name: model?.nameUser, email: model?.email, mobilePhone: model?.phone, gender: model?.gender, birthDate: model?.dateOfBirth.dateFormattedUS(), age: model?.ageYear, isPregnant: nil))
            self.defaultAnalyticsService.trackUserAttribute(Date().getFullDateStringForAnalytics(), key: AnalyticsCustomAttributes.lastOpenTime.rawValue)
        }.disposed(by: self.disposeBag)
        output.consultationList.drive { (list) in
            self.modelMyConsultation = list
        }.disposed(by: self.disposeBag)
        output.bannerData.drive { (data) in
            self.bannerData = data
        }.disposed(by: self.disposeBag)
        output.listMemberOutput.drive { (data) in
            self.modelListMember = data
        }.disposed(by: self.disposeBag)
        output.forceUpdateOutput.drive{ (data) in
            self.updateData = data
            if self.updateData?.isUpdateRequired == true{
                self.onGoToForceUpdate?()
            }
        }.disposed(by: self.disposeBag)
        output.settingOutput.drive{ settingData in
            self.setting = settingData
        }
        output.errorUserDataOutput.drive { [weak self] data in
            self?.errorUserData = data
        }.disposed(by: self.disposeBag)
        output.widgetsOutput.drive { (data) in
            self.widgets = data
        }.disposed(by: self.disposeBag)
        self.checkData()
    }
    
    func setupChangeUser(_ uiData : UserHomeData?){
        if uiData?.email.isNotEmpty == true {
            self.ChangeAccountButton.isHidden = false
            self.ChangeAccountButton.set(type: .blueButtonText, title: "\(uiData?.nameUser ?? "")", titlePosition: .left, font: UIFont(name: "Inter-SemiBold", size: 17)!, icon: #imageLiteral(resourceName: "DownChevronAltea"), iconPosition: .right)
        } else {
            self.ChangeAccountButton.isHidden = true
        }
        
    }
    
    func checkData(){
        if lbName.text == nil {
            self.onSignInTapped?()
        }
    }
    
    // MARK: - UI Setup
    func setupUI(_ dataUser: UserHomeData?) {
        let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
        
        if token.isEmpty {
            self.ivPhotoProfile.isHidden = true
            self.ChangeAccountButton.isHidden = true
            self.lbName.isHidden = true
            self.lbAgePoin.isHidden = true
            self.lbWelcome.isHidden = false
            self.lbSubWelcome.isHidden = false
            self.lbSearchTitle.isHidden = true
            //            self.vEmptyState.isHidden = true
            self.vLogin.isHidden = false
            self.vMyConsultation.isHidden = true
            self.lbName.text = ""
            self.lbAgePoin.text = ""
        } else {
            self.ChangeAccountButton.isHidden = false
            self.lbName.isHidden = true
            self.lbAgePoin.isHidden = false
            self.lbWelcome.isHidden = true
            self.lbSubWelcome.isHidden = true
            self.lbSearchTitle.isHidden = false
            //            self.vEmptyState.isHidden = false
            self.vLogin.isHidden = true
            self.vMyConsultation.isHidden = false
            
            if let urlPhotoPerson = URL(string: dataUser?.userPhoto ?? ""){
                self.ivPhotoProfile.kf.setImage(with: urlPhotoPerson)
            }
            //need fix this, after change
            self.lbName.text = dataUser?.nameUser
            self.lbAgePoin.text = "\(dataUser?.ageYear ?? 0) Tahun \(dataUser?.ageMonth ?? 0) Bulan"
        }
        
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(goToLogin(_:)))
        btnSignIn.addGestureRecognizer(loginGesture)
        
        let searchAutoCompleteGesture = UITapGestureRecognizer(target: self, action: #selector(self.searchAutoCompleteTap(_:)))
        vSearch.addGestureRecognizer(searchAutoCompleteGesture)
        
        self.containerHomeView.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
        self.ivPhotoProfile.makeRounded()
        self.bellImage.isHidden = true
    }
    
    func setupCell() {
        widgetHeight.constant = 0.0
        self.widgetCV.registerNIBForCell(with: MenuCollectionViewCell.self)
        self.widgetCV.dataSource = self
        self.widgetCV.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = (widgetCV.bounds.width / 3 ) - 25
        let height = widgetCV.bounds.height
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let size = CGSize(width: width, height: height)
        layout.itemSize = size
        self.widgetCV.setCollectionViewLayout(layout, animated: true)
        self.menuStackView.setCustomSpacing(16, after:vSearch)
        
        self.cvSpesialist.registerNIBForCell(with: SpesialistCollectionViewCell.self)
        self.cvSpesialist.dataSource = self
        self.cvSpesialist.delegate = self
        
        let nibBannerCell = UINib(nibName: "BannerViewCell", bundle: nil)
        bannerCv.register(nibBannerCell, forCellWithReuseIdentifier: "bannerCell")
        self.bannerCv.configureForPeekingBehavior(behavior: behavior)
        self.bannerCv.dataSource = self
        self.bannerCv.delegate = self
        
        self.pvMyConsultation.register(UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyStateConsultationTodayCell")
        self.pvMyConsultation.register(UINib(nibName: "ConsultationTodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ConsultationTodayCell")
        self.pvMyConsultation.dataSource = self
        self.pvMyConsultation.delegate = self
        
        self.pcMyConsultation.contentHorizontalAlignment = .center
        self.pcMyConsultation.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.pcMyConsultation.itemSpacing = 10
        self.pcMyConsultation.setFillColor(Colors.cGreen, for: .selected)
        self.pcMyConsultation.setFillColor(Colors.cGreenish, for: .normal)
    }
    
    //    private func setupRefresh() {
    //        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    //        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    //        .addSubview(refreshControl)
    //    }
    
    // MARK: - Button Action
    @objc private func refreshAction() {
        self.viewDidLoadRelay.accept(())
    }
    
    @objc func searchAutoCompleteTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.onSearchAutocomplete?()
    }
    
    @objc func goToLogin(_ gestureRecognizer: UITapGestureRecognizer) {
        self.onSignInTapped?()
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == bannerCv {
            return self.bannerData.count
        } else if (collectionView == widgetCV) {
            return self.widgets.count
        } else {
            return self.modelSpecialist.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bannerCv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerViewCell
            if let url = URL(string: bannerData[indexPath.row].imageUrl ?? "") {
                cell.imageView.kf.setImage(with : url)
            }
            return cell
        } else if collectionView == widgetCV{
            let item = self.widgets[indexPath.row]
            let cell = collectionView.dequeueCell(with: MenuCollectionViewCell.self, for: indexPath)!
            cell.menuName.text = item.title
            if let url = URL(string: item.imageUrl) {
                print("urlnya adalah",url)
                cell.menuImage.kf.setImage(with : url)
            }
            return cell
        } else {
            let cell = collectionView.dequeueCell(with: SpesialistCollectionViewCell.self, for: indexPath)!
            if let url = URL(string: modelSpecialist[indexPath.row].iconSmall) {
                cell.ivSpecialistName.kf.setImage(with: url)
            }
            cell.lbSpecialistName.text = self.modelSpecialist[indexPath.row].name
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCv{
            let url = bannerData[indexPath.row].deeplinkUrlIos ?? ""
            let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
            if token.isEmpty{
                self.onSignInTapped?()
            }
            
            if url.contains("vaccine") {
                if let email = userEmail {
                    let vaccineUrl = WebLinkManager.generateVacineUrl(url: url, email: email, token: token)
                    self.onGotoWebView?(vaccineUrl,false)
                } else {
                    self.onSignInTapped?()
                }
            } else {
                self.onGotoWebView?(url,false)
            }
            
        } else if (collectionView == widgetCV){
            let item = widgets[indexPath.row]
            let needLogin = item.needLogin
            let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
            
            
            switch item.deeplinkType {
            case .deepLink:
                switch needLogin && token.isEmpty {
                case true:
                    self.onSignInTapped?()
                case false:
                    callDeeplink(deeplinkUrl: item.deeplinkUrl)
                }
            case .web:
                switch needLogin && token.isEmpty {
                case true:
                    self.onSignInTapped?()
                case false:
                    callWeblink(weblinkUrl: item.deeplinkUrl, needLogin: item.needLogin)
                }
            }
        }
        else {
            self.onTappedListDoctorSpecialization?(
                self.modelSpecialist[indexPath.row].specializationId ?? "",
                self.modelSpecialist[indexPath.row].name ?? "",
                false)
        }
        
    }
    
    func callDeeplink(deeplinkUrl: String) {
        let deepLinkType = DeeplinkManager.checkDeeplinkType(url: deeplinkUrl)
        switch deepLinkType {
        case .teleconsultation:
            self.onGoToDoctorSpecialist?()
        case .none: break
            
        }
    }
    
    func callWeblink(weblinkUrl: String,needLogin: Bool) {
        var url = weblinkUrl
        let webLinkType = WebLinkManager.checkWeblinkType(url: weblinkUrl)
        switch webLinkType {
        case .vaccine:
            url = WebLinkManager.generateVacineUrl(url: weblinkUrl, email: userEmail ?? "", token: token)
        case .none: break
        }
        
        self.onGotoWebView?(url, needLogin)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView == self.bannerCv {
                behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView == self.bannerCv {
                updatePageControlUI(currentPageIndex: behavior.currentIndex)
            }
        }
    }
}

extension HomeVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        var countMyConsultation = 0
        if self.modelMyConsultation.isEmpty {
            countMyConsultation = 1
            self.pcMyConsultation.isHidden = true
        } else {
            countMyConsultation = self.modelMyConsultation.count
            self.pcMyConsultation.isHidden = false
        }
        self.pcMyConsultation.numberOfPages = countMyConsultation
        self.pcMyConsultation.currentPage = 0
        return countMyConsultation
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if self.modelMyConsultation.isEmpty {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "EmptyStateConsultationTodayCell", at: index) as! EmptyStateCollectionViewCell
            cell.setupEmptyCell(page: "ongoingToday")
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ConsultationTodayCell", at: index) as! ConsultationTodayCollectionViewCell
            let target = self.modelMyConsultation[index]
            cell.setupOngoingCosultation(model: target)
            if let settingData = setting {
                cell.setupSettingCallMA(setting: settingData)
            }
            return cell
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pcMyConsultation.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pcMyConsultation.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if self.modelMyConsultation.isEmpty {
            self.showToast(message: "Data kosong")
        } else {
            let consultation = self.modelMyConsultation[index]
            let id = Int(consultation.id) ?? 0
            let code = consultation.orderCode
            switch consultation.statusDetail {
            case "Belum terverifikasi", "Order baru":
                openCosultation(id: id , code: code, isMA: true)
            case "Menunggu Konsultasi", "Memo altea diproses", "Temui Dokter":
                self.onConsultationTapped?(consultation.id, consultation.status)
            case "Sedang Berlangsung":
                openCosultation(id: id, code: code, isMA: false)
            case "Menunggu pembayaran":
                openPayment(consultation: consultation)
            default: break
            }
        }
    }
    
    private func openPayment(consultation: OngoingConsultationModel) {
        let paymentUrl = consultation.transaction?.paymentUrl ?? ""
        let refId = consultation.transaction?.refId ?? ""
        let appointmentId = consultation.id.toInt()
        if !paymentUrl.isEmpty && !refId.isEmpty {
            self.onPaymentContinueTapped?(paymentUrl, appointmentId)
        } else {
            self.onPaymentMethodTapped?(consultation.id)
        }
    }
    
    private func openCosultation(id: Int, code: String, isMA: Bool) {
        switch isMA {
        case true:
            if let settingData = self.setting {
                if settingData.isInOfficeHour() {
                    self.onConsultationCallingTapped?(id, code, isMA)
                } else {
                    onOutsideOperatingHour?(settingData)
                }
            }
        case false:
            self.onConsultationCallingTapped?(id, code, isMA)
            
        }
    }
}
