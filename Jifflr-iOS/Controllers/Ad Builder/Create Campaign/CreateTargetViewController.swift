//
//  CreateTargetViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CreateTargetViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var helpButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderSegmentedControl: GenderSegmentedControl!
    @IBOutlet weak var agesLabel: UILabel!
    @IBOutlet weak var agesSlider: UISlider!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var audienceHeadingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    
    var campaign: Campaign!

    class func instantiateFromStoryboard(campaign: Campaign) -> CreateTargetViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateTargetViewController") as! CreateTargetViewController
        vc.campaign = campaign
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
        
        if Constants.isSmallScreen {
            self.helpButtonBottom.isActive = false
            self.scrollView.isScrollEnabled = true
        } else {
            self.helpButtonBottom.isActive = true
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func setupLocalization() {
        self.title = "createTarget.navigation.title".localized()
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
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(), animated: true)
    }
}
