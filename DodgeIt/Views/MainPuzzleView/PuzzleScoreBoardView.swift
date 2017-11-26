//
//  PuzzleScoreBoardView.swift
//  DodgeIt
//
//  Created by admin on 11/25/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol ScoreBoardButtonDelegate {
    func tappedStore()
    func tappedMenu()
}

class PuzzleScoreBoardView: UIView {
    let currentPlayer: Player
    let storeButton = UIButton()
    let highScoreLabel = UITextView()
    let currentScoreLabel = UILabel()
    let gemCount = UIView()
    let menuButton = UIButton()
    
    var buttonDelegate: ScoreBoardButtonDelegate?
    
    init(currentPlayer: Player) {
        self.currentPlayer = currentPlayer
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        setupViews()
    }
    
    func setupViews() {
        //let scoreBoardView = UIView()
        
        addSubview(storeButton)
        setupStoreButton()
        storeButton.constrainTopTo(anchor: topAnchor, constant: 0)
        storeButton.constrainLeftTo(anchor: leftAnchor, constant: 0)
        storeButton.constrainBottomTo(anchor: bottomAnchor, constant: 0)
        storeButton.constrainWidthTo(dimension: widthAnchor, multiplier: 1/3)
        
        currentScoreLabel.backgroundColor = .clear
        addSubview(currentScoreLabel)
        setupCurrentScoreLabel()
        currentScoreLabel.constrainTopTo(anchor: topAnchor, constant: 0)
        currentScoreLabel.constrainLeftTo(anchor: storeButton.rightAnchor, constant: 0)
        currentScoreLabel.constrainBottomTo(anchor: bottomAnchor, constant: 0)
        currentScoreLabel.constrainWidthTo(dimension: widthAnchor, multiplier: 1/3)
        
        menuButton.backgroundColor = .clear
        addSubview(menuButton)
        setupMenuButton()
        menuButton.constrainTopTo(anchor: topAnchor, constant: 0)
        menuButton.constrainLeftTo(anchor: currentScoreLabel.rightAnchor, constant: 0)
        menuButton.constrainBottomTo(anchor: bottomAnchor, constant: 0)
        menuButton.constrainWidthTo(dimension: widthAnchor, multiplier: 1/3)
    }
    
    func setupStoreButton() {
        storeButton.backgroundColor = .clear
        storeButton.addTarget(self, action: #selector(didTapStoreButton), for: .touchUpInside)
        storeButton.setTitle("Store", for: .normal)
        storeButton.setTitleColor(.white, for: .normal)
    }
    
    func setupCurrentScoreLabel() {
        currentScoreLabel.textAlignment = .center
        currentScoreLabel.textColor = .white
        currentScoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        currentScoreLabel.text = "\(currentPlayer.currentScore)"
    }
    
    func setupMenuButton() {
        menuButton.setTitle("Menu", for: .normal)
        menuButton.setTitleColor(.white, for: .normal)
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
    }
    
    @objc func didTapStoreButton() {
        print("store tapped")
        buttonDelegate?.tappedStore()
    }
    @objc func didTapMenuButton() {
        print("menu tapped")
        buttonDelegate?.tappedMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
