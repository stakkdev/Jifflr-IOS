//
//  AdvertViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class AdvertViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!

    class func instantiateFromStoryboard() -> AdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdvertViewController") as! AdvertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
    }
}

extension AdvertViewController: UINavigationBarDelegate {

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
