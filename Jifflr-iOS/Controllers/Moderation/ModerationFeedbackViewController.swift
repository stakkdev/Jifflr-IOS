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
    @IBOutlet weak var tableView: AdjustedHeightTableView!
    @IBOutlet weak var submitButton: JifflrButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var advert: Advert!
    var expandedIndexpaths:[IndexPath] = []
    var feedback: [(category: ModeratorFeedbackCategory, feedback: [ModeratorFeedback])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var passedFeedback: ModeratorFeedback?
    var selectedFailureFeedbacks: [ModeratorFeedback] = []
    
    class func instantiateFromStoryboard(advert: Advert) -> ModerationFeedbackViewController {
        let storyboard = UIStoryboard(name: "Moderation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModerationFeedbackViewController") as! ModerationFeedbackViewController
        vc.advert = advert
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupUI()
        self.setupNotifications()
        self.setupData()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.tableView.backgroundColor = UIColor.clear
        self.submitButton.setBackgroundColor(color: UIColor.mainPink)
        
        self.passedTextField.delegate = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.isScrollEnabled = false
    }
    
    func setupLocalization() {
        self.title = "moderatorFeedback.navigation.title".localized()
        self.passedLabel.text = "moderatorFeedback.passedLabel.text".localized()
        self.failedLabel.text = "moderatorFeedback.failedLabel.text".localized()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTableViewLayout), name: Constants.Notifications.tableViewHeightChanged, object: self.tableView)
    }
    
    @objc func handleTableViewLayout() {
        if self.tableViewHeight.constant != self.tableView.contentSize.height {
            if self.tableView.contentSize.height == 0.0 {
                self.tableViewHeight.constant = 1.0
            } else {
                self.tableViewHeight.constant = self.tableView.contentSize.height
            }
            self.tableView.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setupData() {
        self.passedTextField.animate()
        ModerationManager.shared.fetchAllModeratorFeedback { (feedback) in
            self.passedTextField.stopAnimating()
            
            guard feedback.count > 0 else {
                self.displayError(error: ErrorMessage.noInternetConnection)
                return
            }
            
            var allFeedback = feedback
            if let passedFeedback = allFeedback.filter({$0.category.passed == true}).first {
                self.passedTextField.text = passedFeedback.category.title
                self.passedFeedback = passedFeedback.feedback.first
                
                if let index = allFeedback.index(where: {$0 == passedFeedback}) {
                    allFeedback.remove(at: index)
                }
            }
            
            self.feedback = allFeedback
        }
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        guard self.validateInput() else {
            self.displayError(error: ErrorMessage.moderationValidation)
            return
        }
    }
    
    func validateInput() -> Bool {
        guard self.passedTextField.tag == 1 || self.selectedFailureFeedbacks.count > 0 else { return false }
        if self.passedTextField.tag == 1 && self.selectedFailureFeedbacks.count > 0 { return false }
        
        return true
    }
}

extension ModerationFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedback.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FailedFeedbackCell") as! FailedFeedbackCell
        cell.feedback = self.feedback[indexPath.row].feedback
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textField.text = self.feedback[indexPath.row].category.title
        cell.expanded = self.expandedIndexpaths.contains(indexPath)
        cell.updateUI(expand: cell.expanded)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let expandedIndexPath = self.expandedIndexpaths.index(of: indexPath) {
            self.expandedIndexpaths.remove(at: expandedIndexPath)
        } else {
            self.expandedIndexpaths.append(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
