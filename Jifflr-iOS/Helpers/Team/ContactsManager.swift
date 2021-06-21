//
//  ContactsManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Contacts

class ContactsManager: NSObject {
    static let shared = ContactsManager()

    var contactStore = CNContactStore()

    func requestAccess(completion: @escaping (Bool) -> Void) {
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)

        switch authStatus {
        case .authorized:
            completion(true)
        case .notDetermined, .restricted:
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, error) in
                if access == true {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        default:
            completion(false)
        }
    }
}
