//
//  TeamPendingFriendCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class TeamPendingFriendCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
