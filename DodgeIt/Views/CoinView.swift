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
    
    init(numberOfCoins: Int) {
        self.numberOfCoins = numberOfCoins
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    func setupViews() {
        numberOfCoinsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCoinsLabel.text = String(numberOfCoins)
        numberOfCoinsLabel.textAlignment = .right
        numberOfCoinsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 50)
        numberOfCoinsLabel.textColor = .white
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
        numberOfCoinsLabel.text = String(cointCount)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
