//
//  ArrowButton.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class ArrowButton: UIButton {

    enum Direction {
        case up
        case right
        case down
        case left
    }
    
    init(target: Any?, action: Selector, direction: Direction) {
        super.init(frame: .zero)
        setupImage(direction: direction)
        backgroundColor = CONSTANTS.COLORS.MENU_BUTTONS
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 30
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setupImage(direction: Direction) {
        let arrowImage = UIImage(imageLiteralResourceName: "arrow")

        switch direction {
        case .up:
            setImage(arrowImage, for: .normal)
        case .right:
            setImage(UIImage(cgImage: arrowImage.cgImage!, scale: 1, orientation: UIImageOrientation.right), for: .normal)
        case .down:
            setImage(UIImage(cgImage: arrowImage.cgImage!, scale: 1, orientation: UIImageOrientation.down), for: .normal)
        case .left:
            setImage(UIImage(cgImage: arrowImage.cgImage!, scale: 1, orientation: UIImageOrientation.left), for: .normal)
            
        }
        //imageView?.image = UIImage(imageLiteralResourceName: "arrow")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
