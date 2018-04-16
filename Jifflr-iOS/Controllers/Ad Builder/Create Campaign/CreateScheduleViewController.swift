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
    @IBOutlet weak var advertTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var dateFromTextField: JifflrTextFieldDate!
    @IBOutlet weak var dateToTextField: JifflrTextFieldDate!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var timeFromTextField: JifflrTextFieldDate!
    @IBOutlet weak var timeToTextField: JifflrTextFieldDate!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var helpButtonBottom: NSLayoutConstraint!
    
    var advert: Advert!
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var selectedDays:[Int] = []
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.layoutIfNeeded()
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.collectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.dateFromTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.dateToTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.timeFromTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.timeToTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        if Constants.isSmallScreen {
            self.helpButtonBottom.isActive = false
            self.scrollView.isScrollEnabled = true
        } else {
            self.helpButtonBottom.isActive = true
            self.scrollView.isScrollEnabled = false
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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

extension CreateScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.titleLabel.text = self.days[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard !Constants.isSmallScreen else { return CGSize(width: 40.0, height: 40.0) }
        
        let totalWidth = UIScreen.main.bounds.width - 36.0
        let spacingWidth = 10.0 * CGFloat(self.days.count)
        let availableWidth = totalWidth - spacingWidth
        let width = availableWidth / CGFloat(self.days.count)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            if cell.roundedView.tag == 0 {
                self.setCellSelected(cell: cell, indexPath: indexPath)
            } else {
                self.setCellUnselected(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func setCellSelected(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 1
        cell.roundedView.backgroundColor = UIColor.mainOrange
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
        
        self.selectedDays.append(indexPath.row)
    }
    
    func setCellUnselected(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 0
        cell.roundedView.backgroundColor = UIColor.white
        cell.titleLabel.textColor = UIColor.mainBlue
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        
        if let index = self.selectedDays.index(of: indexPath.row) {
            self.selectedDays.remove(at: index)
        }
    }
}
