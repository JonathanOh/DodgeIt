//
//  CharacterSkinCell.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol CharacterButtonDelegate {
    func didTapRealMoneyPurchaseButton(character: Character)
    func didTapCoinPurchaseButton(character: Character)
    func didTapSetButton(character: Character)
}

class CharacterSkinCell: UITableViewCell {
    static let reuseID = "skinCell"
    private var character: Character!
    private var skinImageView = UIImageView()
    private var skinLabel = UILabel()
    private var setButton = CharacterSkinCellButton()
    private var coinPurchaseButton = CharacterSkinCellButton()
    private var moneyPurchaseButton = CharacterSkinCellButton()
    private var doesUserOwnSkin: Bool = false
    var buttonDelegate: CharacterButtonDelegate?
    
    func setupCellWith(character: Character, doesUserOwnSkin: Bool) {
        resetAllProperties()
        self.character = character
        self.skinImageView = UIImageView(image: UIImage(imageLiteralResourceName: character.right_facing_asset_name_literal))
        self.skinImageView.contentMode = .scaleAspectFit
        self.doesUserOwnSkin = doesUserOwnSkin
        self.skinLabel.text = character.character_name
        setupViews()
    }
    
    func resetAllProperties() {
        self.character = nil
        self.skinImageView.removeFromSuperview()
        self.skinImageView = UIImageView()
        self.skinLabel.removeFromSuperview()
        self.skinLabel = UILabel()
        self.setButton.removeFromSuperview()
        self.setButton = CharacterSkinCellButton()
        self.coinPurchaseButton.removeFromSuperview()
        self.coinPurchaseButton = CharacterSkinCellButton()
        self.moneyPurchaseButton.removeFromSuperview()
        self.moneyPurchaseButton = CharacterSkinCellButton()
        self.doesUserOwnSkin = false
    }
    
    func setupViews() {
        skinImageView.translatesAutoresizingMaskIntoConstraints = false
        skinImageView.contentMode = .scaleAspectFit
        addSubview(skinImageView)
        skinImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 35).isActive = true
        skinImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        skinImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        skinImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        skinLabel.translatesAutoresizingMaskIntoConstraints = false
        skinLabel.textAlignment = .center
        skinLabel.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 30)
        addSubview(skinLabel)
        skinLabel.widthAnchor.constraint(equalTo: skinImageView.widthAnchor).isActive = true
        skinLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        skinLabel.topAnchor.constraint(equalTo: skinImageView.bottomAnchor).isActive = true
        skinLabel.centerXAnchor.constraint(equalTo: skinImageView.centerXAnchor).isActive = true
        
        let buttonColors = UIColor.getRGBFromArray([37,159,108])
        
        if doesUserOwnSkin {
            let skinIsCurrentlySelected = PlayerDefaults.shared.getSelectedSkinID() == character.character_id
            setButton.setupButton(title: skinIsCurrentlySelected ? "Selected" : "Set", colorOfBackground: skinIsCurrentlySelected ? .gray : buttonColors, target: self, action: #selector(didTapSetButton), displayGem: false)
            addSubview(setButton)
            setButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -35).isActive = true
            setButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            setButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            setButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        } else {
            moneyPurchaseButton.setupButton(title: character.moneyCost, colorOfBackground: buttonColors, target: self, action: #selector(didTapRealMoneyPurchaseButton), displayGem: false)
            addSubview(moneyPurchaseButton)
            coinPurchaseButton.setupButton(title: character.coinCost.getCommaFormattedNumberToString(), colorOfBackground: buttonColors, target: self, action: #selector(didTapCoinPurchaseButton), displayGem: true)
            addSubview(coinPurchaseButton)
            
            let buttonStackView = UIStackView(arrangedSubviews: [moneyPurchaseButton, coinPurchaseButton])
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.axis = .vertical
            buttonStackView.distribution = .fillEqually
            buttonStackView.spacing = 25
            addSubview(buttonStackView)
            
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -35).isActive = true
            buttonStackView.widthAnchor.constraint(equalToConstant: 125).isActive = true
            buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            buttonStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        }
    }
    
    @objc func didTapSetButton() {
        buttonDelegate?.didTapSetButton(character: character)
    }
    
    @objc func didTapRealMoneyPurchaseButton() {
        buttonDelegate?.didTapRealMoneyPurchaseButton(character: character)
    }
    @objc func didTapCoinPurchaseButton() {
        buttonDelegate?.didTapCoinPurchaseButton(character: character)
    }
}

class CharacterSkinCellButton: UIButton {
    init() {
        super.init(frame: .zero)
    }
    func setupButton(title: String = "", colorOfBackground: UIColor?, target: Any?, action: Selector, displayGem: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 30)
        showsTouchWhenHighlighted = true
        backgroundColor = colorOfBackground
        layer.cornerRadius = 5
        addTarget(target, action: action, for: .touchUpInside)
        
        if displayGem {
            let coinImageView = UIImageView(image: UIImage(imageLiteralResourceName: "yellow_gem"))
            coinImageView.contentMode = .scaleAspectFit
            coinImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(coinImageView)
            coinImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
            coinImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
            //coinImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            coinImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
