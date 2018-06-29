//
//  AdvertCell.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdvertCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusImageViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handleStatus(status: String?) {
        guard let status = status else {
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
            return
        }

        switch status {
        case CampaignStatusKey.availableActive:
            self.drawCircle(color: UIColor.mainGreen)
        case CampaignStatusKey.pendingModeration:
            self.drawCircle(color: UIColor.mainGreen)
        case CampaignStatusKey.availableScheduled:
            self.setTimerImage(color: UIColor.mainGreen)
        case CampaignStatusKey.inactive:
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
        case CampaignStatusKey.nonCompliant:
            self.drawCircle(color: UIColor.mainRed)
        case CampaignStatusKey.prepareToDelete:
            self.setTimerImage(color: UIColor.mainRed)
        case CampaignStatusKey.nonCompliantScheduled:
            self.setTimerImage(color: UIColor.mainRed)
        default:
            self.drawCircle(color: UIColor.mainRed)
        }
    }
    
    func shouldHideStatus(yes: Bool) {
        self.statusLabel.isHidden = yes
        self.statusImageView.isHidden = yes
    }
    
    func drawCircle(color: UIColor) {
        self.statusImageView.backgroundColor = color
        self.statusImageView.layer.cornerRadius = 7.0
        self.statusImageView.layer.masksToBounds = true
        self.statusImageView.image = nil
        self.statusImageViewWidth.constant = 14.0
    }
    
    func setTimerImage(color: UIColor) {
        self.statusImageView.backgroundColor = UIColor.clear
        self.statusImageView.layer.cornerRadius = 0.0
        self.statusImageViewWidth.constant = 18.0
        
        let image = UIImage(named: "AdvertScheduledTimer")!.withRenderingMode(.alwaysTemplate)
        self.statusImageView.image = image
        self.statusImageView.tintColor = color
    }
    
    func handleDate(createdAt: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        if let createdAt = createdAt {
            self.dateLabel.text = dateFormatter.string(from: createdAt)
        }
    }
}
