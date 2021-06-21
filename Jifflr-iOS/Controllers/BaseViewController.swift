//
//  BaseViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, DisplayMessage {

    var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBackgroundImageView()
        self.setupNavigationBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    func setupBackgroundImageView() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.backgroundColor = UIColor.blue
        self.view.addSubview(self.backgroundImageView)
        self.view.sendSubview(toBack: self.backgroundImageView)
    }

    func setBackgroundImage(image: UIImage?) {
        self.backgroundImageView.image = image
    }

    func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor.white

        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
}
