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
    @IBOutlet var textFieldBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableBackgroundViewBottom: NSLayoutConstraint!
    
    var expanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.textField.isUserInteractionEnabled = false
        
        self.updateUI(expand: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(expand: Bool) {
        self.expanded = expand
        
        if expand {
            self.textField.isHidden = true
            self.textFieldBottom.isActive = false
            
            self.tableBackgroundView.isHidden = false
            self.tableBackgroundView.isUserInteractionEnabled = true
            self.tableBackgroundViewBottom.isActive = true
            self.tableBackgroundViewBottom.constant = 10.0
        } else {
            self.textField.isHidden = false
            self.textFieldBottom.isActive = true
            
            self.tableBackgroundView.isHidden = true
            self.tableBackgroundView.isUserInteractionEnabled = false
            self.tableBackgroundViewBottom.isActive = false
            self.textFieldBottom.constant = 10.0
        }
    }
}
