//
//  ModerationFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ModerationFeedbackViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passedLabel: UILabel!
    @IBOutlet weak var passedTextField: JifflrTextFieldInvitation!
    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: JifflrButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var advert: Advert!
    
    class func instantiateFromStoryboard(advert: Advert) -> ModerationFeedbackViewController {
        let storyboard = UIStoryboard(name: "Moderation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModerationFeedbackViewController") as! ModerationFeedbackViewController
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.tableView.backgroundColor = UIColor.clear
        self.submitButton.setBackgroundColor(color: UIColor.mainPink)
        
        self.passedTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupLocalization() {
        self.title = "moderatorFeedback.navigation.title".localized()
        self.passedLabel.text = "moderatorFeedback.passedLabel.text".localized()
        self.failedLabel.text = "moderatorFeedback.failedLabel.text".localized()
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        
    }
}

extension ModerationFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FailedFeedbackCell") as! FailedFeedbackCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textField.text = "Hello"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FailedFeedbackCell else { return }
        cell.updateUI(expand: !cell.expanded)
        self.tableView.setNeedsUpdateConstraints()
        self.tableView.updateConstraintsIfNeeded()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension ModerationFeedbackViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.passedTextField {
            if textField.tag == 0 {
                textField.tag = 1
                textField.backgroundColor = UIColor.mainOrange
                textField.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
                textField.textColor = UIColor.white
            } else {
                textField.tag = 0
                textField.backgroundColor = UIColor.white
                textField.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
                textField.textColor = UIColor.mainBlue
            }
            
            return false
        }
        
        return true
    }
}
