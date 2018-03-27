//
//  AddContentViewController+Constraints.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit

extension AddContentViewController {
    func setupConstraints() {
        guard let template = self.advert.details?.template else { return }
        
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.messageTextView.translatesAutoresizingMaskIntoConstraints = false
        self.imageOverlayView.translatesAutoresizingMaskIntoConstraints = false
        self.imageButton.translatesAutoresizingMaskIntoConstraints = false
        
        switch template.key {
        case AdvertTemplateKey.imageVideoPortait:
            self.setupImageVideoPortait()
        case AdvertTemplateKey.imageVideoLandscape:
            self.setupImageVideoLandscape()
        case AdvertTemplateKey.titleMessageImage:
            self.setupTitleMessageImage()
        case AdvertTemplateKey.titleImageMessage:
            self.setupTitleImageMessage()
        case AdvertTemplateKey.imageTitleMessage:
            self.setupImageTitleMessage()
        default:
            return
        }
    }
    
    func setupImageVideoPortait() {
        let overlayLeading = NSLayoutConstraint(item: self.imageOverlayView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let overlayTrailing = NSLayoutConstraint(item: self.imageOverlayView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let overlayHeight = NSLayoutConstraint(item: self.imageOverlayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 230.0)
        let overlayCenterY = NSLayoutConstraint(item: self.imageOverlayView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([overlayLeading, overlayHeight, overlayTrailing, overlayCenterY])
        
        let buttonCenterX = NSLayoutConstraint(item: self.imageButton, attribute: .centerX, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let buttonCenterY = NSLayoutConstraint(item: self.imageButton, attribute: .centerY, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([buttonCenterX, buttonCenterY])
        
        self.titleTextField.isHidden = true
        self.messageTextView.isHidden = true
        self.imageOverlayView.isHidden = false
        self.imageButton.isHidden = false
    }
    
    func setupImageVideoLandscape() {
        self.setupImageVideoPortait()
    }
    
    func setupTitleMessageImage() {
        let titleLeading = NSLayoutConstraint(item: self.titleTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let titleTrailing = NSLayoutConstraint(item: self.titleTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleHeight = NSLayoutConstraint(item: self.titleTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 67.0)
        let titleTop = NSLayoutConstraint(item: self.titleTextField, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([titleLeading, titleTrailing, titleHeight, titleTop])
        
        let messageLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.titleTextField, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let messageTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.titleTextField, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let messageHeight = NSLayoutConstraint(item: self.messageTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140.0)
        let messageTop = NSLayoutConstraint(item: self.messageTextView, attribute: .top, relatedBy: .equal, toItem: self.titleTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraints([messageLeading, messageTrailing, messageHeight, messageTop])
        
        let overlayLeading = NSLayoutConstraint(item: self.imageOverlayView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let overlayTrailing = NSLayoutConstraint(item: self.imageOverlayView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let overlayBottom = NSLayoutConstraint(item: self.imageOverlayView, attribute: .bottom, relatedBy: .equal, toItem: self.previewButton, attribute: .top, multiplier: 1.0, constant: -36.0)
        let overlayTop = NSLayoutConstraint(item: self.imageOverlayView, attribute: .top, relatedBy: .equal, toItem: self.messageTextView, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraints([overlayLeading, overlayBottom, overlayTrailing, overlayTop])
        
        let buttonCenterX = NSLayoutConstraint(item: self.imageButton, attribute: .centerX, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let buttonCenterY = NSLayoutConstraint(item: self.imageButton, attribute: .centerY, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([buttonCenterX, buttonCenterY])
        
        self.titleTextField.isHidden = false
        self.messageTextView.isHidden = false
        self.imageOverlayView.isHidden = false
        self.imageButton.isHidden = false
    }
    
    func setupTitleImageMessage() {
        let titleLeading = NSLayoutConstraint(item: self.titleTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let titleTrailing = NSLayoutConstraint(item: self.titleTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleHeight = NSLayoutConstraint(item: self.titleTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 67.0)
        let titleTop = NSLayoutConstraint(item: self.titleTextField, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([titleLeading, titleTrailing, titleHeight, titleTop])
        
        let messageLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.titleTextField, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let messageTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.titleTextField, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let messageHeight = NSLayoutConstraint(item: self.messageTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140.0)
        let messageBottom = NSLayoutConstraint(item: self.messageTextView, attribute: .bottom, relatedBy: .equal, toItem: self.previewButton, attribute: .top, multiplier: 1.0, constant: -15.0)
        self.view.addConstraints([messageLeading, messageTrailing, messageHeight, messageBottom])
        
        let overlayLeading = NSLayoutConstraint(item: self.imageOverlayView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let overlayTrailing = NSLayoutConstraint(item: self.imageOverlayView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let overlayBottom = NSLayoutConstraint(item: self.imageOverlayView, attribute: .bottom, relatedBy: .equal, toItem: self.messageTextView, attribute: .top, multiplier: 1.0, constant: -15.0)
        let overlayTop = NSLayoutConstraint(item: self.imageOverlayView, attribute: .top, relatedBy: .equal, toItem: self.titleTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraints([overlayLeading, overlayBottom, overlayTrailing, overlayTop])
        
        let buttonCenterX = NSLayoutConstraint(item: self.imageButton, attribute: .centerX, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let buttonCenterY = NSLayoutConstraint(item: self.imageButton, attribute: .centerY, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([buttonCenterX, buttonCenterY])
        
        self.titleTextField.isHidden = false
        self.messageTextView.isHidden = false
        self.imageOverlayView.isHidden = false
        self.imageButton.isHidden = false
    }
    
    func setupImageTitleMessage() {
        let titleLeading = NSLayoutConstraint(item: self.titleTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 18.0)
        let titleTrailing = NSLayoutConstraint(item: self.titleTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -18.0)
        let titleHeight = NSLayoutConstraint(item: self.titleTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 67.0)
        let titleBottom = NSLayoutConstraint(item: self.titleTextField, attribute: .bottom, relatedBy: .equal, toItem: self.messageTextView, attribute: .top, multiplier: 1.0, constant: -15.0)
        self.view.addConstraints([titleLeading, titleTrailing, titleHeight, titleBottom])
        
        let messageLeading = NSLayoutConstraint(item: self.messageTextView, attribute: .leading, relatedBy: .equal, toItem: self.titleTextField, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let messageTrailing = NSLayoutConstraint(item: self.messageTextView, attribute: .trailing, relatedBy: .equal, toItem: self.titleTextField, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let messageHeight = NSLayoutConstraint(item: self.messageTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140.0)
        let messageBottom = NSLayoutConstraint(item: self.messageTextView, attribute: .bottom, relatedBy: .equal, toItem: self.previewButton, attribute: .top, multiplier: 1.0, constant: -35.0)
        self.view.addConstraints([messageLeading, messageTrailing, messageHeight, messageBottom])
        
        let overlayLeading = NSLayoutConstraint(item: self.imageOverlayView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let overlayTrailing = NSLayoutConstraint(item: self.imageOverlayView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let overlayBottom = NSLayoutConstraint(item: self.imageOverlayView, attribute: .bottom, relatedBy: .equal, toItem: self.titleTextField, attribute: .top, multiplier: 1.0, constant: -15.0)
        let overlayTop = NSLayoutConstraint(item: self.imageOverlayView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([overlayLeading, overlayBottom, overlayTrailing, overlayTop])
        
        let buttonCenterX = NSLayoutConstraint(item: self.imageButton, attribute: .centerX, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let buttonCenterY = NSLayoutConstraint(item: self.imageButton, attribute: .centerY, relatedBy: .equal, toItem: self.imageOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([buttonCenterX, buttonCenterY])
        
        self.titleTextField.isHidden = false
        self.messageTextView.isHidden = false
        self.imageOverlayView.isHidden = false
        self.imageButton.isHidden = false
    }
}
