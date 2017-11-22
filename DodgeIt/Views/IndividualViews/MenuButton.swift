//
//  MenuButton.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/13/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    let buttonImage: UIImage?

    init(target: Any?, action: Selector, buttonTitle: String?, buttonImage: UIImage?) {
        self.buttonImage = buttonImage
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action: action, for: .touchUpInside)
        layer.cornerRadius = 5
        setTitle(buttonTitle ?? "", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = CONSTANTS.COLORS.MENU_BUTTONS
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        setupButtonImage()
    }
    
    func setupButtonImage() {
        if let imageExists = buttonImage {
            let buttonImageView = UIImageView(image: imageExists)
            buttonImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(buttonImageView)
            buttonImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            buttonImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
            buttonImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
            buttonImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
