//
//  WithdrawnHistoryCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class WithdrawnHistoryCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
