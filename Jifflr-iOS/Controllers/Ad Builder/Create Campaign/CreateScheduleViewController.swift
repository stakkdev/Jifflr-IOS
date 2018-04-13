//
//  CreateScheduleViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 13/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CreateScheduleViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var campaignNameTextField: JifflrTextField!
    @IBOutlet weak var advertLabel: UILabel!
    @IBOutlet weak var advertTextField: JifflrTextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var dateFromTextField: JifflrTextField!
    @IBOutlet weak var dateToTextField: JifflrTextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var timeFromTextField: JifflrTextField!
    @IBOutlet weak var timeToTextField: JifflrTextField!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var helpButton: JifflrButton!
    
    var advert: Advert!
    
    class func instantiateFromStoryboard(advert: Advert) -> CreateScheduleViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateScheduleViewController") as! CreateScheduleViewController
        vc.advert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    func setupLocalization() {
        self.title = "createAd.navigation.title".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.setupHelpButtonAttributedTitle()
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
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func helpButtonPressed(sender: UIButton) {
        
    }
}
