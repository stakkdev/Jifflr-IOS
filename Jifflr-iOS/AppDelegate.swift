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
import Localize_Swift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        print("Running environment: \(Constants.currentEnvironment.rawValue)")
        print("Running language: \(Session.shared.currentLanguage)")

        UIApplication.shared.statusBarStyle = .lightContent

        //FirebaseApp.configure()
        //AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(UserDefaultsManager.shared.analyticsOn())

        if UserDefaultsManager.shared.crashTrackerOn() {
            Fabric.with([Crashlytics.self])
        }

        self.configParse(in: application, with: launchOptions)
        self.configAdmob()
        self.configKeyboard()
        self.configLanguage()

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PushHandler.syncNotificationSettings()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

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
        FeedbackQuestion.registerSubclass()
        FeedbackType.registerSubclass()
        UserSeenAdvert.registerSubclass()
        UserFeedback.registerSubclass()
        UserCashout.registerSubclass()

        Parse.initialize(with: configuration)
    }
}

extension AppDelegate {
    func configAdmob() {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6220129917785469~1943942885")
    }

    func configKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
    }

    func configLanguage() {
        guard let languageCode = Locale.current.languageCode else { return }
        Localize.setCurrentLanguage(languageCode)
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
                UserDefaultsManager.shared.setNotifications(on: granted)
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        UserDefaultsManager.shared.setNotifications(on: !notificationSettings.types.isEmpty)
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
