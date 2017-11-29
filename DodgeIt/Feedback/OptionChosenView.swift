//
//  OptionChosenView.swift
//  DodgeIt
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import Firebase

class OptionChosenView: UIView {
    let chosenOption: FeedbackContainerView.FeedbackOption
    init(chosenOption: FeedbackContainerView.FeedbackOption) {
        self.chosenOption = chosenOption
        super.init(frame: .zero)
        setupViews()
        backgroundColor = CONSTANTS.COLORS.DARKER_DEFAULT
        Analytics.logEvent("feedback_\(chosenOption.rawValue)", parameters: nil)
    }
    
    func setupViews() {
        switch chosenOption {
        case .loveThisGame:
            let writeReviewButton = FeedbackChosenButton(target: self, selector: #selector(didTapWriteReviewButton), title: "Write a review", fontSize: 35)
            addSubview(writeReviewButton)
            
            let contactUsButton = FeedbackChosenButton(target: self, selector: #selector(didTapContactUsButton), title: "Contact Us", fontSize: 35)
            addSubview(contactUsButton)
            
            let buttonStack = UIStackView(arrangedSubviews: [writeReviewButton, contactUsButton])
            buttonStack.axis = .vertical
            buttonStack.distribution = .fillEqually
            buttonStack.spacing = 15
            
            addSubview(buttonStack)
            buttonStack.constrainFullyToSuperView()
        case .issues, .suggestions, .thisGameSucks:
            let contactUsButton = FeedbackChosenButton(target: self, selector: #selector(didTapContactUsButton), title: "Contact Us", fontSize: 35)
            addSubview(contactUsButton)
            contactUsButton.constrainCenterXTo(anchor: centerXAnchor)
            contactUsButton.constrainCenterYTo(anchor: centerYAnchor, constant: frame.height/9)
            contactUsButton.constrainWidthTo(dimension: widthAnchor, multiplier: 0.85)
            contactUsButton.constrainHeightTo(dimension: heightAnchor, multiplier: 0.4)
        }
    }
    
    @objc func didTapWriteReviewButton() {
        AppDelegate.rateApp(appId: CONSTANTS.APP_APPLE_ID) { (completed) in
            print("success!! on tapping feedback app!")
        }
    }
    
    @objc func didTapContactUsButton() {
        let subject = chosenOption.rawValue
        let body = "My Device ID is: \(UIDevice.current.identifierForVendor!.uuidString)"
        let coded = "mailto:support@splodeybound.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL:NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open(emailURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FeedbackChosenButton: UIButton {
    init(target: Any, selector: Selector, title: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: fontSize)
        addTarget(target, action: selector, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
