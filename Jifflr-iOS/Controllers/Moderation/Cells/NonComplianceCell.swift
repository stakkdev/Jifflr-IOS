//
//  NonComplianceCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class NonComplianceCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
