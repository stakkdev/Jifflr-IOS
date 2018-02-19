//
//  CashoutCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol CashoutCellDelegate: class {
    func cashoutCellPressed()
}

class CashoutCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!

    weak var delegate: CashoutCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cashoutPressed(sender:)))
        self.roundedView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func cashoutPressed(sender: UITapGestureRecognizer) {
        self.delegate?.cashoutCellPressed()
    }
}
