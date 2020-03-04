//
//  DashboardViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import MBProgressHUD

class DashboardViewController: BaseViewController {

    var timer: Timer?
    var advert: Advert?
    var campaign: Campaign?
    var moderatorCampaign: Campaign?
    var myAds: MyAds?
    var internetAlertShown = false

    @IBOutlet weak var playAdsButton: PulsePlayButton!
    @IBOutlet weak var myTeamButton: DashboardButtonLeft!
    @IBOutlet weak var myMoneyButton: DashboardButtonLeft!
    @IBOutlet weak var adBuilderButton: DashboardButtonRight!
    @IBOutlet weak var adsViewedButton: DashboardButtonRight!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var moderateButton: UIButton!
    @IBOutlet weak var helpButtonTop: NSLayoutConstraint!
    @IBOutlet weak var helpButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var moderateButtonTop: NSLayoutConstraint!

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
    }

    func setupUI() {
        self.setupLocalization()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

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
        
        self.setupModerateButton()
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
    
    func setupModerateButton() {
        let title = "dashboard.moderateButton.title".localized()
        let font = UIFont(name: Constants.FontNames.GothamMedium, size: 14.0)!
        let attributes = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ] as [NSAttributedStringKey: Any]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.moderateButton.setAttributedTitle(attributedTitle, for: .normal)
        self.moderateButtonTop.constant = Constants.isSmallScreen ? 8.0 : 20.0
        
        guard let moderatorStatus = Session.shared.currentUser?.details.moderatorStatus else { return }
        
        if moderatorStatus == ModeratorStatusKey.isModerator {
            self.moderateButton.isHidden = false
            self.moderateButton.isEnabled = true
            self.helpButtonTop.constant = 30.0
            self.helpButtonBottom.constant = 68.0
        } else {
            self.moderateButton.isHidden = true
            self.moderateButton.isEnabled = false
            self.helpButtonTop.constant = 50.0
            self.helpButtonBottom.constant = 48.0
        }
    }

    func updateData() {
        
        if !UserDefaultsManager.shared.firstLoadComplete() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }

        if Reachability.isConnectedToNetwork() {
            let group = DispatchGroup()
            
            group.enter()
            DashboardManager.shared.fetchStats { (stats, error) in
                group.leave()
                guard let stats = stats, error == nil else {
                    self.displayError(error: error)
                    self.updateLocalData()
                    return
                }

                self.updateUI(stats: stats)
            }
            
            group.enter()
            self.updateLocalAdvert()
            AdvertManager.shared.fetch {
                self.updateLocalAdvert()
                group.leave()
            }
            
            MyAdsManager.shared.fetchMyAds()
            group.enter()
            MyAdsManager.shared.fetchData { (myAds) in
                self.myAds = myAds
                group.leave()
            }
            
            AppSettingsManager.shared.updateQuestionDuration()
            
            group.notify(queue: .main) {
                if !UserDefaultsManager.shared.firstLoadComplete() {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UserDefaultsManager.shared.setfirstLoadComplete(on: true)
                }
            }
            
            self.updateModerationCampaign()
        } else {
            self.updateLocalData()
            self.updateLocalAdvert()
        }
    }
    
    func updateModerationCampaign() {
        ModerationManager.shared.fetchCampaign { (campaign) in
            self.moderatorCampaign = campaign
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
        AdvertManager.shared.fetchNextLocal(completion: { (object) in
            if let campaign = object as? Campaign {
                self.campaign = campaign
            } else if let advert = object as? Advert {
                self.advert = advert
            }
        })
        
        AdvertManager.shared.fetchDefaultAdExchange { (advert) in
            self.advert = advert
        }
    }

    func updateUI(stats: DashboardStats) {
        DispatchQueue.main.async {
            self.myTeamButton.setValue(value: stats.teamSize)
            self.myMoneyButton.valueLabel.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", stats.money))"
            self.adsViewedButton.valueLabel.text = "\(stats.adsViewed)/\(stats.adTotal)"
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
            
            guard AppSettingsManager.shared.canViewAds else {
                self.displayError(error: ErrorMessage.maxCampaignsLimitReached)
                return
            }

            if let campaign = self.campaign {
                let navController = UINavigationController(rootViewController: CMSAdvertViewController.instantiateFromStoryboard(campaign: campaign, mode: AdViewMode.normal))
                navController.isNavigationBarHidden = false
                navController.modalPresentationStyle = .fullScreen
                self.navigationController?.present(navController, animated: false, completion: nil)

                self.campaign = nil
            } else  if let advert = self.advert {
                let navController = UINavigationController(rootViewController: AdvertViewController.instantiateFromStoryboard(advert: advert))
                navController.isNavigationBarHidden = true
                navController.modalPresentationStyle = .fullScreen
                self.navigationController?.present(navController, animated: false, completion: nil)
            } else {
                self.retryAdvertFetch()
            }
        } else {
            self.rootLocationRequiredViewController()
        }
    }

    func retryAdvertFetch() {
        self.updateData()
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
        self.navigationController?.pushViewController(AdBuilderLandingViewController.instantiateFromStoryboard(myAds: self.myAds), animated: true)
    }

    @IBAction func helpButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(), animated: true)
    }
    
    @IBAction func moderateAdsButtonPressed(_ sender: UIButton) {
        if let campaign = self.moderatorCampaign {
            let navController = UINavigationController(rootViewController: CMSAdvertViewController.instantiateFromStoryboard(campaign: campaign, mode: AdViewMode.moderator))
            navController.isNavigationBarHidden = false
            self.navigationController?.present(navController, animated: false, completion: nil)
            self.moderatorCampaign = nil
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.moderateButton.isEnabled = false
            ModerationManager.shared.fetchCampaign { (newCampaign) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.moderateButton.isEnabled = true
                
                guard let newCampaign = newCampaign else {
                    self.displayError(error: ErrorMessage.noAdsToModerate)
                    return
                }
                
                self.moderatorCampaign = newCampaign
                let navController = UINavigationController(rootViewController: CMSAdvertViewController.instantiateFromStoryboard(campaign: newCampaign, mode: AdViewMode.moderator))
                navController.isNavigationBarHidden = false
                self.navigationController?.present(navController, animated: false, completion: nil)
                self.moderatorCampaign = nil
            }
        }
    }
}
