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
import GoogleMobileAds
import Localize_Swift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        print("Running environment: \(Constants.currentEnvironment.rawValue)")
        print("Running language: \(Locale.current.languageCode ?? "")")

        UIApplication.shared.statusBarStyle = .lightContent

        //FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
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

    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
}

// Parse Config
extension AppDelegate {
    func configParse(in application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        let configuration = ParseClientConfiguration {
            $0.applicationId = "ad-m8"
            $0.server = Constants.currentEnvironment.appURL
            $0.clientKey = "vmN358nahRWnB3nTeyzxgyX7q28Lz4fN"
            $0.isLocalDatastoreEnabled = true
            $0.networkRetryAttempts = 2
        }

        // Register Subclasses
        PendingUser.registerSubclass()
        Advert.registerSubclass()
        FeedbackQuestion.registerSubclass()
        FeedbackType.registerSubclass()
        Location.registerSubclass()
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
