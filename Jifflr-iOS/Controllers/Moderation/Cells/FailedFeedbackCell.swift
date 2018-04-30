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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.textField.isUserInteractionEnabled = false
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        } else {
            self.textField.backgroundColor = UIColor.white
            self.textField.addRightImage(image: UIImage(named: "AnswerDropdown")!)
            self.textField.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
            self.textField.textColor = UIColor.mainBlue
            self.textFieldBackgroundView.isHidden = true
            
            self.tableBackgroundView.isHidden = true
            self.tableBackgroundView.isUserInteractionEnabled = false
        }
        
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = !self.expanded ? 0.0 : self.tableView.contentSize.height
    }
}

extension FailedFeedbackCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FailureReasonCell") as! FailureReasonCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
}
