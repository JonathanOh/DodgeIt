//
//  CoinView.swift
//  DodgeIt
//
//  Created by admin on 11/19/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class CoinView: UIView {
    
    private var coinImageView = UIImageView()
    let numberOfCoins: Int
    let numberOfCoinsLabel = UILabel()
    private var font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 65)
    private var textColor: UIColor = .black
    
    init(numberOfCoins: Int, textFont: UIFont?, fontColor: UIColor?) {
        self.numberOfCoins = numberOfCoins
        if let fontExists = textFont {
            self.font = fontExists
        }
        if let textColorExists = fontColor {
            self.textColor = textColorExists
        }
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    func setupViews() {
        numberOfCoinsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCoinsLabel.text = numberOfCoins.getCommaFormattedNumberToString()
        numberOfCoinsLabel.textAlignment = .right
        numberOfCoinsLabel.font = font
        numberOfCoinsLabel.textColor = textColor
        numberOfCoinsLabel.adjustsFontSizeToFitWidth = true
        addSubview(numberOfCoinsLabel)
        numberOfCoinsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        numberOfCoinsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        numberOfCoinsLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        numberOfCoinsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        
        coinImageView = UIImageView(image: UIImage(imageLiteralResourceName: "yellow_gem"))
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coinImageView)
        coinImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        coinImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        coinImageView.leftAnchor.constraint(equalTo: numberOfCoinsLabel.rightAnchor, constant: 8).isActive = true
        coinImageView.centerYAnchor.constraint(equalTo: numberOfCoinsLabel.centerYAnchor, constant: 0).isActive = true
//        
//        coinImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        coinImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        coinImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        coinImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
    
    func updateCoinCount(_ cointCount: Int) {
        numberOfCoinsLabel.text = cointCount.getCommaFormattedNumberToString()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
