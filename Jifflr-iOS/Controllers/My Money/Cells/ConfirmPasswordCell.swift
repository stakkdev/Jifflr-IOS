//
//  ConfirmPasswordCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol ConfirmPasswordCellDelegate: class {
    func passwordTextFieldDidEnd(text: String)
}

class ConfirmPasswordCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordTextField: JifflrTextFieldPassword!

    var delegate: ConfirmPasswordCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
        self.passwordTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ConfirmPasswordCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.delegate?.passwordTextFieldDidEnd(text: text)
    }
}
