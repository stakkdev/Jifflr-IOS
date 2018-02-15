//
//  DashboardViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {

    var timer: Timer?

    @IBOutlet weak var playAdsButton: PulsePlayButton!
    @IBOutlet weak var myTeamButton: DashboardButtonLeft!
    @IBOutlet weak var myMoneyButton: DashboardButtonLeft!
    @IBOutlet weak var adBuilderButton: DashboardButtonRight!
    @IBOutlet weak var adsViewedButton: DashboardButtonRight!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var sloganLabel: UILabel!

    class func instantiateFromStoryboard() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            self.playAdsButton.pulse()
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.timer?.invalidate()
        self.timer = nil
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "DashboardBackground"))

        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.myTeamButton.setBackgroundColor(color: UIColor.mainOrange)
        self.adsViewedButton.setBackgroundColor(color: UIColor.mainPink)
        self.myMoneyButton.setBackgroundColor(color: UIColor.mainGreen)
        self.adBuilderButton.setBackgroundColor(color: UIColor.mainLightBlue)

        self.myTeamButton.setImage(image: UIImage(named: "DashboardButtonMyTeam"))
        self.myTeamButton.setValue(value: 310)

        self.myMoneyButton.setImage(image: UIImage(named: "DashboardButtonMyMoney"))
        self.myMoneyButton.setValue(value: 1020)

        self.adsViewedButton.setImage(image: UIImage(named: "DashboardButtonAdsViewed"))
        self.adsViewedButton.setValue(value: 9103)

        self.adBuilderButton.setImage(image: UIImage(named: "DashboardButtonAdBuilder"))
        self.adBuilderButton.setValue(value: 3)
    }

    func setupLocalization() {
        self.adBuilderButton.setName(text: "dashboard.adBuilderButton.title".localized())
        self.adsViewedButton.setName(text: "dashboard.adsViewedButton.title".localized())
        self.myMoneyButton.setName(text: "dashboard.myMoneyButton.title".localized())
        self.myTeamButton.setName(text: "dashboard.myTeamButton.title".localized())

        self.setupHelpButtonAttributedTitle()
        self.setupSloganAttributedTitle()
    }

    func setupHelpButtonAttributedTitle() {
        let title = "dashboard.helpButton.title".localized()
        let helpWords = title.components(separatedBy: " ")
        guard helpWords.count > 1, let lastWord = helpWords.last else {
            self.helpButton.setTitle(title, for: .normal)
            return
        }

        let range = (title as NSString).range(of: lastWord)
        guard range.location != NSNotFound else {
            self.helpButton.setTitle(title, for: .normal)
            return
        }

        let font = UIFont(name: Constants.FontNames.GothamBold, size: 20)!
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.mainOrange, range: range)
        self.helpButton.setAttributedTitle(attributedString, for: .normal)
    }

    func setupSloganAttributedTitle() {
        let title = "dashboard.slogan".localized()
        let helpWords = title.components(separatedBy: "\n")
        guard helpWords.count > 1, let lastWord = helpWords.last else {
            self.sloganLabel.text = title
            return
        }

        let range = (title as NSString).range(of: lastWord)
        guard range.location != NSNotFound else {
            self.sloganLabel.text = title
            return
        }

        let font = UIFont(name: Constants.FontNames.GothamBold, size: 28)!
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.mainOrange]
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range)
        self.sloganLabel.attributedText = attributedString
    }

    @IBAction func profileButtonPressed(sender: UIButton) {

    }

    @IBAction func playAdsButtonPressed(_ sender: UIButton) {
        //self.navigationController?.present(AdvertViewController.instantiateFromStoryboard(), animated: true, completion: nil)
    }

    @IBAction func teamButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(TeamViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func cashOutButtonPressed(_ sender: UIButton) {
        //self.navigationController?.pushViewController(CashoutViewController.instantiateFromStoryboard(), animated: true)
    }
}
