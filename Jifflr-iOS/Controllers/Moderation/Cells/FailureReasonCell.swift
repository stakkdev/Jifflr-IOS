//
//  FailureReasonCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 30/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class FailureReasonCell: UITableViewCell {
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.checkmarkImageView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.checkmarkImageView.image = UIImage(named: "TemplateSelected")
        } else {
            self.checkmarkImageView.image = UIImage(named: "TemplateUnselected")
        }
    }
}
