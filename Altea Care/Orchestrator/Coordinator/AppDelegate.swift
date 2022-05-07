//
//  AppDelegate.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import IQKeyboardManagerSwift
import MidtransKit
import FirebaseCore
import FBSDKCoreKit
import MoEngage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()
    let notificationCenter = NotificationCenter.default
    
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.notificationCenter.post(name: NSNotification.Name("didBecomeActive"), object: nil)
        AppEvents.shared.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.notificationCenter.post(name: NSNotification.Name("willTerminate"), object: nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController()
        window!.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        
        //SETUP MIDTRANS
        #if DEBUG
        MidtransConfig.shared().setClientKey("SB-Mid-client-dDCkEJkkaPyNfOb3", environment: .sandbox, merchantServerURL: "google.com")
        #else
        MidtransConfig.shared().setClientKey("Mid-client-4I5ghLJtXNmU6ZHA", environment: .production, merchantServerURL: "google.com")
        #endif
        MidtransCreditCardConfig.shared().tokenStorageEnabled = true
        MidtransCreditCardConfig.shared().secure3DEnabled = true
        
        MidtransCreditCardConfig.shared().paymentType = .oneclick
        MidtransCreditCardConfig.shared().saveCardEnabled = true
        
        MidtransConfig.shared().callbackSchemeURL = "myApp://"
        
        let fontSource = MidtransUIFontSource.init(fontNameBold: "Inter-Bold", fontNameRegular: "Inter-Regular", fontNameLight: "Inter-Light")
        MidtransUIThemeManager.applyCustomThemeColor(UIColor.primary, themeFont: fontSource)
        
        setupFirebase()
        setupAnalytics(application, launchOptions: launchOptions)
        setupMoengage(application, launchOptions: launchOptions)
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        
        if let notif = notification,
          let extra = notif["app_extra"] as? [String:Any] {
            let deepLink = DeepLinkOption.build(with: extra)
            applicationCoordinator.start(with: deepLink, indexTab: .tabIndex(5))
            
        }else{
            let deepLink = DeepLinkOption.build(with: notification)
            applicationCoordinator.start(with: deepLink, indexTab: .tabIndex(5))
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if Preference.getBool(forKey: .AlreadyInstall) == nil {
            MoEngage.sharedInstance().appStatus(INSTALL)
            Preference.set(value: true, forKey: .AlreadyInstall)
            Preference.set(value: appVersion, forKey: .DeviceVersion)
        } else {
            if let lastVersion = Preference.getString(forKey: .DeviceVersion), lastVersion != appVersion {
                MoEngage.sharedInstance().appStatus(UPDATE)
                Preference.set(value: appVersion, forKey: .DeviceVersion)
            }
        }
        
        return true
    }
    
    private func makeCoordinator() -> Coordinator {
        return AppCoordinator(
            router: RouterImpl(rootController: self.rootController),
            coordinatorFactory: CoordinatorFactoryImpl()
        )
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
}

extension AppDelegate {
    private func setupFirebase() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else { FirebaseApp.configure() }
    }
}

extension AppDelegate {
    private func setupAnalytics(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        AnalyticsService.setupMultiple(AnalyticsProvider.allCases, application: application, with: launchOptions)
    }
}

// MARK:- UserNotifications + Moengage
extension AppDelegate : UNUserNotificationCenterDelegate{
    private func setupMoengage(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        let moe = MoengageProvider()
        let sdkConfig = MOSDKConfig.init(appID: moe.identifier)
        sdkConfig.appGroupID = moe.appGroupID
        #if DEBUG
        MoEngage.sharedInstance().initializeTest(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
        MoEngage.sharedInstance().initializeLive(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: self)
    }
    
    //Remote notification Registration callback methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngage.sharedInstance().setPushToken(deviceToken)
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngage.sharedInstance().didFailToRegisterForPush()
        print(error)
    }
    
    // MARK:- UserNotifications Framework callback method
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        //Custom Handling of notification if Any
        let pushDictionary = response.notification.request.content.userInfo
        print(pushDictionary)
        guard let extra = pushDictionary["app_extra"] as? [String:Any] else{return}
        let deepLink = DeepLinkOption.build(with: extra)
        applicationCoordinator.startWithNotif(with: deepLink)
        completionHandler();
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //This is to only to display Alert and enable notification sound
        completionHandler([.sound,.alert])
        
    }
    
    // MARK:- Remote notification received callback method for iOS versions below iOS10
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngage.sharedInstance().didReceieveNotificationinApplication(application, withInfo: userInfo)
        
        guard let extra = userInfo["app_extra"] as? [String:Any] else{return}
        let deepLink = DeepLinkOption.build(with: extra)
        applicationCoordinator.startWithNotif(with: deepLink)
    }
}

