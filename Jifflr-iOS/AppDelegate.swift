//
//  AppDelegate.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics
import Firebase
import Parse
import UserNotifications
import GoogleMobileAds
import Appodeal
import Localize_Swift
import IQKeyboardManagerSwift
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        print("Running environment: \(Constants.currentEnvironment.rawValue)")
        print("Running language: \(Session.shared.currentLanguage)")

        UIApplication.shared.statusBarStyle = .lightContent

        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(UserDefaultsManager.shared.analyticsOn())
        
        UserDefaultsManager.shared.setQuestionDuration(time: 5)

        if UserDefaultsManager.shared.crashTrackerOn() {
            Fabric.with([Crashlytics.self])
        }

        self.configParse(in: application, with: launchOptions)
        self.configAdProviders()
        self.configKeyboard()
        self.configLanguage()
        self.configStripe()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.handleDidEnterBackground()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
}

extension AppDelegate {
    func configStripe() {
        STPPaymentConfiguration.shared().publishableKey = Constants.currentEnvironment.stripeKey
        
        STPTheme.default().errorColor = UIColor.mainRed
        STPTheme.default().emphasisFont = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        STPTheme.default().font = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        STPTheme.default().primaryBackgroundColor = UIColor.mainBlue
        STPTheme.default().secondaryForegroundColor = UIColor.greyPlaceholderColor
        STPTheme.default().accentColor = UIColor.white
    }
}

// Parse Config
extension AppDelegate {
    func configParse(in application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        let configuration = ParseClientConfiguration {
            $0.applicationId = "jifflr"
            $0.server = Constants.currentEnvironment.appURL
            $0.isLocalDatastoreEnabled = true
            $0.networkRetryAttempts = 2
        }

        // Register Subclasses
        MyTeam.registerSubclass()
        UserDetails.registerSubclass()
        Friends.registerSubclass()
        PendingUser.registerSubclass()
        Location.registerSubclass()
        LocationFinancial.registerSubclass()
        LocationStatus.registerSubclass()
        Advert.registerSubclass()
        Answer.registerSubclass()
        Question.registerSubclass()
        QuestionType.registerSubclass()
        UserSeenCampaign.registerSubclass()
        QuestionAnswers.registerSubclass()
        UserCashout.registerSubclass()
        UserMonthStats.registerSubclass()
        DashboardStats.registerSubclass()
        MyTeamFriends.registerSubclass()
        Graph.registerSubclass()
        AdsViewed.registerSubclass()
        MyMoney.registerSubclass()
        Language.registerSubclass()
        Demographic.registerSubclass()
        Campaign.registerSubclass()
        Schedule.registerSubclass()
        Gender.registerSubclass()
        AdExchangeQuestion.registerSubclass()
        CampaignToModerate.registerSubclass()

        Parse.initialize(with: configuration)
    }
}

extension AppDelegate {
    func configAdProviders() {
        GADMobileAds.configure(withApplicationID: Constants.currentEnvironment.admobKey)
        Appodeal.setTestingEnabled(false)
        Appodeal.initialize(withApiKey: Constants.currentEnvironment.appodealKey, types: .rewardedVideo)
    }

    func configKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().canAdjustAdditionalSafeAreaInsets = true
    }

    func configLanguage() {
        Localize.setCurrentLanguage(Locale.current.identifier)
    }
}

// Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func configNotification(in application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, _ in
                print("Notification Permissions Granted: \(granted)")
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        guard let currentUser = Session.shared.currentUser else { return }
        currentUser.details.pushNotifications = !notificationSettings.types.isEmpty
        currentUser.saveInBackground()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device token: \(token)")

        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PushHandler.handle(in: application, with: userInfo)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if (error as NSError).code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
}

extension AppDelegate {
    func handleDidEnterBackground() {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }
        guard let navController = rootViewController as? UINavigationController else { return }
        guard let visibleViewController = navController.visibleViewController else { return }
            
        if visibleViewController is AdvertViewController || visibleViewController is CMSAdvertViewController {
            if let visibleViewController = visibleViewController as? CMSAdvertViewController, visibleViewController.mode != AdViewMode.normal {
                return
            }
            
            rootViewController.rootDashboardViewController()
        }
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrientationManager.shared.orientation
    }
}
