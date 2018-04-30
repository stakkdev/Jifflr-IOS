//
//  FailedFeedbackCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class FailedFeedbackCell: UITableViewCell {
    
    @IBOutlet weak var textField: JifflrTextFieldDropdown!
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableView: AdjustedHeightTableView!
    @IBOutlet weak var textFieldBackgroundView: UIView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    var expanded = false
    var feedback: [ModeratorFeedback] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.textField.isUserInteractionEnabled = false
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentOffset = CGPoint.zero
        self.tableView.isScrollEnabled = false
        self.tableView.rowHeight = 32
        self.tableView.estimatedRowHeight = 32
        self.tableView.allowsMultipleSelection = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(expand: Bool) {
        self.expanded = expand
        
        if expand {
            self.textField.backgroundColor = UIColor.orange
            self.textField.rightView = nil
            self.textField.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
            self.textField.textColor = UIColor.white
            self.textFieldBackgroundView.isHidden = false
            
            self.tableBackgroundView.isHidden = false
            self.tableBackgroundView.isUserInteractionEnabled = true
            
            self.tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        } else {
            self.textField.backgroundColor = UIColor.white
            self.textField.addRightImage(image: UIImage(named: "AnswerDropdown")!)
            self.textField.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
            self.textField.textColor = UIColor.mainBlue
            self.textFieldBackgroundView.isHidden = true
            
            self.tableBackgroundView.isHidden = true
            self.tableBackgroundView.isUserInteractionEnabled = false
            
            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
        self.tableView.reloadData()
        let height = self.tableView.contentSize.height + self.tableView.contentInset.top + self.tableView.contentInset.bottom
        self.tableViewHeight.constant = !self.expanded ? 0.0 : height
    }
}

extension FailedFeedbackCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedback.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FailureReasonCell") as! FailureReasonCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.reasonLabel.text = self.feedback[indexPath.row].title
        return cell
    }
}
