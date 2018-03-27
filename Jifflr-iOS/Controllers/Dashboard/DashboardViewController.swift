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
    var advert: Advert?
    var internetAlertShown = false

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

        self.updateData()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !Reachability.isConnectedToNetwork() && self.internetAlertShown == false {
            self.displayMessage(title: AlertMessage.noInternetConnection.title, message: AlertMessage.noInternetConnection.message)
            self.internetAlertShown = true
        }

        self.playAdsButton.pulse()
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.playAdsButton.pulse()
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.timer?.invalidate()
        self.timer = nil
        self.advert = nil
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
        self.myMoneyButton.setImage(image: UIImage(named: "DashboardButtonMyMoney"))
        self.adsViewedButton.setImage(image: UIImage(named: "DashboardButtonAdsViewed"))
        self.adBuilderButton.setImage(image: UIImage(named: "DashboardButtonAdBuilder"))
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

    func updateData() {

        if Reachability.isConnectedToNetwork() {
            DashboardManager.shared.fetchStats { (stats, error) in
                guard let stats = stats, error == nil else {
                    self.displayError(error: error)
                    self.updateLocalData()
                    return
                }

                self.updateUI(stats: stats)
            }

            AdvertManager.shared.fetch {
                self.updateLocalAdvert()
            }
        } else {
            self.updateLocalData()
            self.updateLocalAdvert()
        }
    }

    func updateLocalData() {
        DashboardManager.shared.fetchLocalStats { (stats, error) in
            guard let stats = stats, error == nil else {
                self.displayError(error: error)
                return
            }

            self.updateUI(stats: stats)
        }
    }

    func updateLocalAdvert() {
        AdvertManager.shared.fetchNextLocal(completion: { (advert) in
            self.advert = advert
        })
    }

    func updateUI(stats: DashboardStats) {
        DispatchQueue.main.async {
            self.myTeamButton.setValue(value: stats.teamSize)
            self.myMoneyButton.setValue(value: stats.money)
            self.adsViewedButton.setValue(value: stats.adsViewed)
            self.adBuilderButton.setValue(value: stats.adsCreated)
        }
    }

    @IBAction func profileButtonPressed(sender: UIButton) {
        self.navigationController?.pushViewController(ProfileViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func playAdsButtonPressed(_ sender: UIButton) {
        if LocationManager.shared.locationServicesEnabled() == true {
            guard LocationManager.shared.canViewAdverts() else {
                self.displayError(error: ErrorMessage.blockedCountry)
                return
            }
            
            guard let advert = self.advert else {
                self.retryAdvertFetch()
                return
            }

            if advert.isCMS {
                let navController = UINavigationController(rootViewController: CMSAdvertViewController.instantiateFromStoryboard(advert: advert, isPreview: false))
                navController.isNavigationBarHidden = true
                self.navigationController?.present(navController, animated: false, completion: nil)
            } else {
                let navController = UINavigationController(rootViewController: AdvertViewController.instantiateFromStoryboard(advert: advert))
                navController.isNavigationBarHidden = true
                self.navigationController?.present(navController, animated: false, completion: nil)
            }
        } else {
            self.rootLocationRequiredViewController()
        }
    }

    func retryAdvertFetch() {
        let error = ErrorMessage.advertFetchFailed
        self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil, dismissAction: { (action) in
            self.updateData()
        })
    }

    @IBAction func teamButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(TeamViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func myMoneyButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyMoneyViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func adsViewedPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(AdsViewedViewController.instantiateFromStoryboard(), animated: true)
    }
    
    @IBAction func adBuilderPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(AdBuilderLandingViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func helpButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(), animated: true)
    }
}
