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
    static let goal = "goal:reached"
}

enum PushHandler {
    case text(String)
    case goal

    func push() {
        switch self {
        case .text(let message):
            print(message)
            // TODO: Handle a default push notification with no type
            return
        case .goal:
            // TODO: Handle an example custom goal notification. e.g Present 'goals' view controller or perform some action.
            return
        }
    }

    static func handle(in application: UIApplication, with userInfo: [AnyHashable: Any]) {
        guard let apsDict = userInfo["aps"] as? [AnyHashable: Any], let message = apsDict["alert"] as? String else {
            print("Invalid alert")
            return
        }

        if let type = userInfo["type"] as? String {
            switch type {
            case PushTypes.goal:
                PushHandler.goal.push()
                return
            default:
                break
            }
        }

        PushHandler.text(message).push()
    }

    static func syncNotificationSettings() {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                if (UserDefaultsManager.shared.notificationsOn()) && settings.authorizationStatus == UNAuthorizationStatus.denied {
                    UserDefaultsManager.shared.setNotifications(on: false)
                }
            }
        } else {
            if (UserDefaultsManager.shared.notificationsOn()) && application.currentUserNotificationSettings?.types.isEmpty == true {
                UserDefaultsManager.shared.setNotifications(on: false)
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
