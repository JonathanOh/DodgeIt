//
//  CongratsPurchaseView.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class CongratsPurchaseView: UIView {
    let character: Character
    let textView = UITextView()
    init(character: Character) {
        self.character = character
       // super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        addGestureRecognizer(tapGestureRecognizer)
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alpha = 0
        setupViews()
        triggerAnimation()
    }
    
    @objc func didTapScreen() {
        removeFromSuperview()
    }
    
    func setupViews() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Congratulations!\nyou purchased:"
        textView.font = UIFont(name: "HelveticaNeue-Thin", size: 40)
        textView.textAlignment = .center
        textView.textColor = .white
        textView.backgroundColor = UIColor.clear
        //textView.frame = CGRect(x: 50, y: 50, width: frame.width * 0.75, height: 100)
        addSubview(textView)

        textView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -120).isActive = true
        textView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        textView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let characterImageView = UIImageView(image: UIImage(imageLiteralResourceName: character.right_facing_asset_name_literal))
        characterImageView.backgroundColor = .clear
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(characterImageView)
        characterImageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        characterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        characterImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        
        let textLabel = UILabel()
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.text = "Tap anywhere to dismiss"
        textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 59).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
    }
    
    func triggerAnimation() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.alpha = 1
        }) { [weak self] (complete) in
            self?.isUserInteractionEnabled = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
