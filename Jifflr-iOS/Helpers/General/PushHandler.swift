//
//  PushHandler.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 21/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct PushTypes {
    static let adDeficit = "adOverview"
    static let invitationAccepted = "teamOverview"
    static let joinTeam = "teamOverview"
    static let newCampaignToModerator = "campaignToModerate"
    static let payoutPush = "moneyOverview"
}

enum PushHandler {
    case text(String)
    case adDeficit(String)
    case invitationAccepted(String)
    case joinTeam(String)
    case newCampaignToModerator(String)
    case payoutPush(String)

    func push() {
        switch self {
        case .text(let message):
            self.pushViewController(viewController: nil, message: message)
            return
        case .adDeficit(let message):
            let adsViewed = AdsViewedViewController.instantiateFromStoryboard()
            self.pushViewController(viewController: adsViewed, message: message)
            return
        case .invitationAccepted(let message):
            let myTeam = TeamViewController.instantiateFromStoryboard()
            self.pushViewController(viewController: myTeam, message: message)
            return
        case .joinTeam(let message):
            let myTeam = TeamViewController.instantiateFromStoryboard()
            self.pushViewController(viewController: myTeam, message: message)
            return
        case .newCampaignToModerator(let message):
            self.pushViewController(viewController: nil, message: message)
            return
        case .payoutPush(let message):
            let myMoney = MyMoneyViewController.instantiateFromStoryboard()
            self.pushViewController(viewController: myMoney, message: message)
            return
        }
    }
    
    private func pushViewController(viewController: UIViewController?, message: String) {
        if let vc = UIApplication.shared.keyWindow?.topMostWindowController() {
            
            let title = "alert.notification.title".localized()
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelTitle = "alert.notifications.cancelButton".localized()
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            
            let continueTitle = "alert.notification.continue".localized()
            let continueAction = UIAlertAction(title: continueTitle, style: .default) { (action) in
                let dashboardVC = DashboardViewController.instantiateFromStoryboard()
                let navVC = UINavigationController(rootViewController: dashboardVC)
                navVC.isNavigationBarHidden = true
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.window!.rootViewController = navVC
                
                if let viewController = viewController {
                    viewController.navigationItem.setHidesBackButton(true, animated: false)
                    navVC.pushViewController(viewController, animated: true)
                }
            }
            alertController.addAction(continueAction)
            
            vc.present(alertController, animated: true, completion: nil)
        }
    }

    static func handle(in application: UIApplication, with userInfo: [AnyHashable: Any]) {
        guard let apsDict = userInfo["aps"] as? [AnyHashable: Any], let message = apsDict["alert"] as? String else {
            print("Invalid alert")
            return
        }

        if let type = apsDict["type"] as? String {
            switch type {
            case PushTypes.adDeficit:
                PushHandler.adDeficit(message).push()
                return
            case PushTypes.invitationAccepted:
                PushHandler.invitationAccepted(message).push()
                return
            case PushTypes.joinTeam:
                PushHandler.joinTeam(message).push()
                return
            case PushTypes.newCampaignToModerator:
                PushHandler.newCampaignToModerator(message).push()
                return
            case PushTypes.payoutPush:
                PushHandler.payoutPush(message).push()
                return
            default:
                break
            }
        }

        PushHandler.text(message).push()
    }

    static func syncNotificationSettings() {
        guard let currentUser = Session.shared.currentUser else { return }

        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                if currentUser.details.pushNotifications && settings.authorizationStatus == UNAuthorizationStatus.denied {
                    currentUser.details.pushNotifications = false
                    currentUser.saveInBackground()
                }
            }
        } else {
            if currentUser.details.pushNotifications && application.currentUserNotificationSettings?.types.isEmpty == true {
                currentUser.details.pushNotifications = false
                currentUser.saveInBackground()
            }
        }
    }

    static func requestNotificationEnabled(completionHandler: @escaping (Bool) -> Void) {
        let application = UIApplication.shared
        let controller = application.keyWindow?.currentViewController()
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .notDetermined {
                    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                    center.requestAuthorization(options: options) { granted, _ in
                        completionHandler(granted)
                    }
                } else if settings.authorizationStatus == .denied {
                    controller?.requestGoToAppSettings(confirm: { completionHandler(false) }, cancel: { completionHandler(false) })
                } else {
                    completionHandler(true)
                }
            }
        } else {
            let currentSettings = application.currentUserNotificationSettings
            if currentSettings?.types.isEmpty != false {
                controller?.requestGoToAppSettings(confirm: { completionHandler(false) }, cancel: { completionHandler(false) })
            } else {
                completionHandler(true)
            }
        }
    }
}
