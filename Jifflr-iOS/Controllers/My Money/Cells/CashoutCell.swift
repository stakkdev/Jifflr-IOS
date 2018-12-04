//
//  CashoutCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol CashoutCellDelegate: class {
    func cashoutCellPressed(cell: CashoutCell)
}

class CashoutCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    weak var delegate: CashoutCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
        self.activityIndicator.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cashoutPressed(sender:)))
        self.roundedView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func cashoutPressed(sender: UITapGestureRecognizer) {
        self.animate()
        self.delegate?.cashoutCellPressed(cell: self)
    }

    func animate() {
        self.nameLabel.isHidden = true
        self.amountLabel.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }

    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.nameLabel.isHidden = false
        self.amountLabel.isHidden = false
    }
}
