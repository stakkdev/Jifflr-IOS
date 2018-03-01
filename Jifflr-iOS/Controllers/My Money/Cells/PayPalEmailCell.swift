//
//  PayPalEmailCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol PaypalEmailCellDelegate: class {
    func paypalEmailTextFieldDidEnd(text: String)
}

class PayPalEmailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!

    var delegate: PaypalEmailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
        self.emailTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PayPalEmailCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.delegate?.paypalEmailTextFieldDidEnd(text: text)
    }
}
