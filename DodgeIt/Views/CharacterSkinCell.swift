//
//  CharacterSkinCell.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class CharacterSkinCell: UITableViewCell {
    static let reuseID = "skinCell"
    private var character: Character!
    private var skinImageView = UIImageView()
    private var skinLabel = UILabel()
    private var setButton = UIButton()
    private var coinPurchaseButton = UIButton()
    private var moneyPurchaseButton = UIButton()
    private var doesUserOwnSkin: Bool = false
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
        self.setButton = UIButton()
        self.coinPurchaseButton.removeFromSuperview()
        self.coinPurchaseButton = UIButton()
        self.moneyPurchaseButton.removeFromSuperview()
        self.moneyPurchaseButton = UIButton()
        self.doesUserOwnSkin = false
    }
    
    func setupViews() {
        skinImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skinImageView)
        skinImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 35).isActive = true
        skinImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        skinImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        skinImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        skinLabel.translatesAutoresizingMaskIntoConstraints = false
        skinLabel.textAlignment = .center
        addSubview(skinLabel)
        skinLabel.widthAnchor.constraint(equalTo: skinImageView.widthAnchor).isActive = true
        skinLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        skinLabel.topAnchor.constraint(equalTo: skinImageView.bottomAnchor).isActive = true
        skinLabel.centerXAnchor.constraint(equalTo: skinImageView.centerXAnchor).isActive = true
        
        if doesUserOwnSkin {
            setButton.translatesAutoresizingMaskIntoConstraints = false
            setButton.setTitle("Set", for: .normal)
            setButton.backgroundColor = .green
            setButton.layer.cornerRadius = 3
            addSubview(setButton)
            setButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -35).isActive = true
            setButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            setButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            setButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        } else {
            moneyPurchaseButton.translatesAutoresizingMaskIntoConstraints = false
            moneyPurchaseButton.setTitle(character.moneyCost, for: .normal)
            moneyPurchaseButton.backgroundColor = .green
            moneyPurchaseButton.layer.cornerRadius = 3
            addSubview(moneyPurchaseButton)
            moneyPurchaseButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
            moneyPurchaseButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            coinPurchaseButton.translatesAutoresizingMaskIntoConstraints = false
            coinPurchaseButton.setTitle(String(character.coinCost), for: .normal)
            coinPurchaseButton.backgroundColor = .green
            coinPurchaseButton.layer.cornerRadius = 3
            addSubview(coinPurchaseButton)
            coinPurchaseButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
            coinPurchaseButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
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
}
