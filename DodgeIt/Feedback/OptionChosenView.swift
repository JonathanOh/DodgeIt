//
//  OptionChosenView.swift
//  DodgeIt
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class OptionChosenView: UIView {
    let chosenOption: FeedbackContainerView.FeedbackOption
    init(chosenOption: FeedbackContainerView.FeedbackOption) {
        self.chosenOption = chosenOption
        super.init(frame: .zero)
        setupViews()
        backgroundColor = .red
    }
    
    func setupViews() {
        switch chosenOption {
        case .loveThisGame:
            let writeReviewButton = UIButton()
            writeReviewButton.backgroundColor = .white
            writeReviewButton.layer.cornerRadius = 5
            writeReviewButton.layer.shadowColor = UIColor.black.cgColor
            writeReviewButton.layer.shadowOpacity = 1
            writeReviewButton.layer.shadowOffset = CGSize.zero
            writeReviewButton.layer.shadowRadius = 5
            writeReviewButton.setTitle("Write a review", for: .normal)
            writeReviewButton.setTitleColor(.black, for: .normal)
            writeReviewButton.titleLabel?.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 35)
            writeReviewButton.addTarget(self, action: #selector(didTapWriteReviewButton), for: .touchUpInside)
            addSubview(writeReviewButton)
            
            let contactUsButton = UIButton()
            contactUsButton.backgroundColor = .white
            contactUsButton.layer.cornerRadius = 5
            contactUsButton.layer.shadowColor = UIColor.black.cgColor
            contactUsButton.layer.shadowOpacity = 1
            contactUsButton.layer.shadowOffset = CGSize.zero
            contactUsButton.layer.shadowRadius = 3
            contactUsButton.setTitle("Contact us", for: .normal)
            contactUsButton.setTitleColor(.black, for: .normal)
            contactUsButton.titleLabel?.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 35)
            contactUsButton.addTarget(self, action: #selector(didTapContactUsButton), for: .touchUpInside)
            addSubview(contactUsButton)
            
            let buttonStack = UIStackView(arrangedSubviews: [writeReviewButton, contactUsButton])
            buttonStack.axis = .vertical
            buttonStack.distribution = .fillEqually
            buttonStack.spacing = 15
            
            addSubview(buttonStack)
            buttonStack.constrainFullyToSuperView()
            
            break
        case .issues, .suggestions, .thisGameSucks:
            break
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
        let coded = "mailto:support@splodeybound.com?subject=\(subject)&footer=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
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
