//
//  MyMoneyManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 28/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class MyMoneyManager: NSObject {
    static let shared = MyMoneyManager()
    let pinName = "MyMoney"

    func fetch(completion: @escaping (MyMoney?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "my-money-overview", withParameters: ["user": user.objectId!]) { myMoneyJSON, error in
            if let myMoneyJSON = myMoneyJSON as? [String: Any] {
                let myMoney = MyMoney()

                if let points = myMoneyJSON["graph"] as? [[Double]] {
                    var graph:[Graph] = []
                    for point in points {
                        guard point.count == 2 else { continue }
                        
                        let graphPoint = Graph()
                        graphPoint.x = point.first!
                        graphPoint.y = point.last!
                        graph.append(graphPoint)
                    }
                    
                    myMoney.graph = graph
                }

                if let totalWithdrawn = myMoneyJSON["totalWithdrawn"] as? Double {
                    myMoney.totalWithdrawn = totalWithdrawn
                }

                if let moneyAvailable = myMoneyJSON["moneyAvailable"] as? Double {
                    myMoney.moneyAvailable = moneyAvailable
                }

                if let history = myMoneyJSON["history"] as? [UserCashout] {
                    myMoney.history = history
                }

                PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                    myMoney.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("MyMoney Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })
                })

                completion(myMoney, nil)
            } else {
                completion(nil, ErrorMessage.unknown)
            }
        }
    }

    func fetchLocal(completion: @escaping (MyMoney?, ErrorMessage?) -> Void) {
        let query = MyMoney.query()
        query?.includeKey("graph")
        query?.includeKey("history")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.getFirstObjectInBackground(block: { (myMoney, error) in
            guard let myMoney = myMoney as? MyMoney, error == nil else {
                completion(nil, ErrorMessage.unknown)
                return
            }

            completion(myMoney, nil)
        })
    }
}
