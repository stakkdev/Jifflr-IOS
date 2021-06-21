//
//  AdjustedHeightTableView.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 30/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdjustedHeightTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        NotificationCenter.default.post(name: Constants.Notifications.tableViewHeightChanged, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
