//
//  MenuButton.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/13/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
////        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
////        playButton.setTitle("Play", for: .normal)
////        playButton.setTitleColor(.black, for: .normal)
////        playButton.backgroundColor = CONSTANTS.COLORS.BACKGROUND_VIEW
////        playButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
////        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        addTar
//    }
    init(target: Any?, action: Selector, buttonTitle: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action: action, for: .touchUpInside)
        layer.cornerRadius = 5
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = CONSTANTS.COLORS.BACKGROUND_VIEW
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
