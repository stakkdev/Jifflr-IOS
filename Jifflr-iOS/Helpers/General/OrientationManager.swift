//
//  OrientationManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation

class OrientationManager: NSObject {
    static let shared = OrientationManager()
    
    public var orientation = UIInterfaceOrientationMask.portrait
    
    func set(orientation: UIInterfaceOrientationMask) {
        self.orientation = orientation
    }
}
