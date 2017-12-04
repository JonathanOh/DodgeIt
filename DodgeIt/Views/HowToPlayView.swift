//
//  HowToPlayView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 12/4/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class HowToPlayView: UIView {
    
    let titleLabel = UILabel()
    let swipeToMoveView = UIView()
    let gameObjectiveTextView = UITextView()
    let coinInfoTextView = UITextView()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        addGestureRecognizer(tapGestureRecognizer)
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alpha = 0
        setupViews()
        triggerViewAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapScreen() {
        PlayerDefaults.shared.setUserDidViewGameInstructions()
        removeFromSuperview()
    }
    
    func setupViews() {
        let deviceSmallerThan6 = UIScreen.main.bounds.width < 370
        
        titleLabel.text = "How to Play"
        titleLabel.textColor = .white
        //titleLabel.backgroundColor = .purple
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 60)
        addSubview(titleLabel)
        titleLabel.constrainTopTo(anchor: topAnchor, constant: 15)
        titleLabel.constrainWidthTo(dimension: widthAnchor)
        titleLabel.constrainHeightTo(dimension: heightAnchor, multiplier: 1/8)
        titleLabel.constrainCenterXTo(anchor: centerXAnchor)
        
        let borderOne = UIView()
        borderOne.backgroundColor = .gray
        addSubview(borderOne)
        borderOne.constrainTopTo(anchor: titleLabel.bottomAnchor)
        borderOne.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderOne.constrainWidthTo(dimension: widthAnchor, multiplier: 0.9)
        borderOne.constrainCenterXTo(anchor: centerXAnchor)
        
        let swipeToMoveTextLabel = UILabel()
        swipeToMoveTextLabel.text = "Swipe to Move"
        swipeToMoveTextLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 45)
        swipeToMoveTextLabel.textColor = .white
        swipeToMoveTextLabel.textAlignment = .center
        swipeToMoveView.addSubview(swipeToMoveTextLabel)
        swipeToMoveTextLabel.constrainTopTo(anchor: swipeToMoveView.topAnchor, constant: 15)
        swipeToMoveTextLabel.constrainCenterXTo(anchor: swipeToMoveView.centerXAnchor)
        swipeToMoveTextLabel.constrainHeightTo(dimension: swipeToMoveView.heightAnchor, multiplier: 1/6)
        swipeToMoveTextLabel.constrainWidthTo(dimension: swipeToMoveView.widthAnchor)
        let arrowPad = ArrowPadView()
        arrowPad.isUserInteractionEnabled = false
        swipeToMoveView.addSubview(arrowPad)
        arrowPad.constrainTopTo(anchor: swipeToMoveTextLabel.bottomAnchor, constant: 15)
        arrowPad.constrainWidthTo(dimension: swipeToMoveView.widthAnchor, multiplier: 1/2)
        arrowPad.constrainHeightTo(dimension: swipeToMoveView.widthAnchor, multiplier: 1/2)
        arrowPad.constrainCenterXTo(anchor: swipeToMoveView.centerXAnchor)
        
        addSubview(swipeToMoveView)
        swipeToMoveView.constrainTopTo(anchor: borderOne.bottomAnchor)
        swipeToMoveView.constrainCenterXTo(anchor: centerXAnchor)
        swipeToMoveView.constrainWidthTo(dimension: widthAnchor, multiplier: 0.75)
        swipeToMoveView.constrainHeightTo(dimension: heightAnchor, multiplier: 1/3)
        
        let borderTwo = UIView()
        borderTwo.backgroundColor = .gray
        addSubview(borderTwo)
        borderTwo.constrainTopTo(anchor: swipeToMoveView.bottomAnchor)
        borderTwo.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderTwo.constrainWidthTo(dimension: widthAnchor, multiplier: 0.9)
        borderTwo.constrainCenterXTo(anchor: centerXAnchor)
        
        gameObjectiveTextView.text = "Move upwards to advance to the next level, but don't let the Splodey's touch you!"
        gameObjectiveTextView.textAlignment = .center
        gameObjectiveTextView.isEditable = false
        gameObjectiveTextView.isSelectable = false
        gameObjectiveTextView.backgroundColor = .clear
        gameObjectiveTextView.textColor = .white
        gameObjectiveTextView.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: deviceSmallerThan6 ? 25 : 30)
        
        let gameObjectiveView = UIView()
        gameObjectiveView.addSubview(gameObjectiveTextView)
        gameObjectiveTextView.constrainTopTo(anchor: gameObjectiveView.topAnchor)
        gameObjectiveTextView.constrainCenterXTo(anchor: gameObjectiveView.centerXAnchor)
        gameObjectiveTextView.constrainWidthTo(dimension: gameObjectiveView.widthAnchor, multiplier: 1)
        gameObjectiveTextView.constrainHeightTo(dimension: gameObjectiveView.heightAnchor, multiplier: 55/100)
        let splodeyImageView = UIImageView(image: UIImage(imageLiteralResourceName: "explosion0"))
        gameObjectiveView.addSubview(splodeyImageView)
        splodeyImageView.constrainTopTo(anchor: gameObjectiveTextView.bottomAnchor, constant: 5)
        splodeyImageView.constrainCenterXTo(anchor: gameObjectiveView.centerXAnchor)
        splodeyImageView.constrainWidthTo(dimension: gameObjectiveView.heightAnchor, multiplier: 35/100)
        splodeyImageView.constrainHeightTo(dimension: gameObjectiveView.heightAnchor, multiplier: 35/100)
        addSubview(gameObjectiveView)
        gameObjectiveView.constrainTopTo(anchor: borderTwo.bottomAnchor)
        gameObjectiveView.constrainWidthTo(dimension: widthAnchor, multiplier: 0.85)
        gameObjectiveView.constrainHeightTo(dimension: heightAnchor, multiplier: 1/5)
        gameObjectiveView.constrainCenterXTo(anchor: centerXAnchor)
        
        let borderThree = UIView()
        borderThree.backgroundColor = .gray
        addSubview(borderThree)
        borderThree.constrainTopTo(anchor: gameObjectiveView.bottomAnchor)
        borderThree.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderThree.constrainWidthTo(dimension: widthAnchor, multiplier: 0.9)
        borderThree.constrainCenterXTo(anchor: centerXAnchor)
        
        coinInfoTextView.text = "Gain coins by completing levels or picking them up! Check out the store to redeem!"
        coinInfoTextView.textAlignment = .center
        coinInfoTextView.isEditable = false
        coinInfoTextView.isSelectable = false
        coinInfoTextView.backgroundColor = .clear
        coinInfoTextView.textColor = .white
        coinInfoTextView.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: deviceSmallerThan6 ? 25 : 30)
        let coinInfoView = UIView()
        coinInfoView.addSubview(coinInfoTextView)
        coinInfoTextView.constrainTopTo(anchor: coinInfoView.topAnchor)
        coinInfoTextView.constrainCenterXTo(anchor: coinInfoView.centerXAnchor)
        coinInfoTextView.constrainWidthTo(dimension: coinInfoView.widthAnchor, multiplier: 1)
        coinInfoTextView.constrainHeightTo(dimension: coinInfoView.heightAnchor, multiplier: 55/100)
        let coinImageView = UIImageView(image: UIImage(imageLiteralResourceName: "yellow_gem"))
        coinInfoView.addSubview(coinImageView)
        coinImageView.constrainTopTo(anchor: coinInfoTextView.bottomAnchor, constant: 5)
        coinImageView.constrainCenterXTo(anchor: coinInfoView.centerXAnchor)
        coinImageView.constrainWidthTo(dimension: coinInfoView.heightAnchor, multiplier: 35/100)
        coinImageView.constrainHeightTo(dimension: coinInfoView.heightAnchor, multiplier: 35/100)
        addSubview(coinInfoView)
        coinInfoView.constrainTopTo(anchor: borderThree.bottomAnchor)
        coinInfoView.constrainWidthTo(dimension: widthAnchor, multiplier: 0.85)
        coinInfoView.constrainHeightTo(dimension: heightAnchor, multiplier: 1/5)
        coinInfoView.constrainCenterXTo(anchor: centerXAnchor)
        
        let dismissLabel = UILabel()
        dismissLabel.text = "Tap anywhere to dismiss."
        dismissLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 30)
        dismissLabel.textAlignment = .center
        //dismissLabel.backgroundColor = .purple
        dismissLabel.textColor = .white
        addSubview(dismissLabel)
        dismissLabel.constrainTopTo(anchor: coinInfoView.bottomAnchor, constant: 12)
        dismissLabel.constrainCenterXTo(anchor: centerXAnchor)
        dismissLabel.constrainWidthTo(dimension: widthAnchor)
        dismissLabel.constrainHeightTo(dimension: heightAnchor, multiplier: 1/12)
    }
    
    func triggerViewAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: { [weak self] in
            self?.alpha = 1
        }) { [weak self] (completed) in
            self?.isUserInteractionEnabled = true
        }
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (timer) in
//
//        }
    }
}
