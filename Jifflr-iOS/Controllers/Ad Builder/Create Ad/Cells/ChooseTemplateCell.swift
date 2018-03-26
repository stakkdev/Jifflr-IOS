//
//  ChooseTemplateCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ChooseTemplateCell: UITableViewCell {
    
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.selectedImageView.backgroundColor = UIColor.blue
        } else {
            self.selectedImageView.backgroundColor = UIColor(red: 39/255, green: 35/255, blue: 97/255, alpha: 0.1)
        }
    }
}
