//
//  PayPalEmailCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class PayPalEmailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
