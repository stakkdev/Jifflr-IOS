//
//  SettingsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var notificationsHeadingLabel: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var dataCollectionsHeadingLabel: UILabel!
    @IBOutlet weak var dataCollectionsLabel: UILabel!
    @IBOutlet weak var crashTrackerHeadingLabel: UILabel!
    @IBOutlet weak var crashTrackerLabel: UILabel!
    @IBOutlet weak var crashTrackerSwitch: UISwitch!
    @IBOutlet weak var analyticsHeadingLabel: UILabel!
    @IBOutlet weak var analyticsLabel: UILabel!
    @IBOutlet weak var analyticsSwitch: UISwitch!

    class func instantiateFromStoryboard() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.scrollView.layoutSubviews()
        
        let width = self.scrollView.frame.width
        let height = self.analyticsLabel.frame.origin.y + self.analyticsLabel.frame.size.height + 50.0
        self.scrollView.contentSize = CGSize(width: width, height: height)
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.crashTrackerSwitch.isOn = UserDefaultsManager.shared.crashTrackerOn()
        self.analyticsSwitch.isOn = UserDefaultsManager.shared.analyticsOn()

        guard let currentUser = Session.shared.currentUser else { return }
        self.notificationsSwitch.isOn = currentUser.details.pushNotifications
    }

    func setupLocalization() {
        self.title = "settings.navigation.title".localized()
        self.notificationsHeadingLabel.text = "settings.notifications.heading".localized()
        self.dataCollectionsHeadingLabel.text = "settings.dataCollections.heading".localized()
        self.dataCollectionsLabel.text = "settings.dataCollections.message".localized()
        self.crashTrackerHeadingLabel.text = "settings.crashTracker.heading".localized()
        self.crashTrackerLabel.text = "settings.crashTracker.message".localized()
        self.analyticsHeadingLabel.text = "settings.analytics.heading".localized()
        self.analyticsLabel.text = "settings.analytics.message".localized()
    }

    @IBAction func notificationsChanged(sender: UISwitch) {
        SettingsManager.shared.toggleNotifications(on: sender.isOn)
    }

    @IBAction func crashTrackerChanged(sender: UISwitch) {
        SettingsManager.shared.toggleCrashTracker(on: sender.isOn)
    }

    @IBAction func analyticsChanged(sender: UISwitch) {
        SettingsManager.shared.toggleAnalytics(on: sender.isOn)
    }
}
