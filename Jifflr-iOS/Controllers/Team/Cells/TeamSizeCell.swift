//
//  TeamSizeCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class TeamSizeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
