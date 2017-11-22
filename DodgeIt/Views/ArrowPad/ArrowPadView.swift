//
//  ArrowPadView.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol ArrowDirectionEventDelegate {
    func didTapArrow(_ direction: ArrowButton.Direction)
}

class ArrowPadView: UIView {
    let allDirections: [ArrowButton.Direction] = [.up, .right, .down, .left]
    var arrowDelegate: ArrowDirectionEventDelegate?
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupArrowButtons()
    }
    // about 200 total width and height
    func setupArrowButtons() {
        let upArrow = ArrowButton(target: self, action: #selector(didTapUpArrow), direction: .up)
        let rightArrow = ArrowButton(target: self, action: #selector(didTapRightArrow), direction: .right)
        let downArrow = ArrowButton(target: self, action: #selector(didTapDownArrow), direction: .down)
        let leftArrow = ArrowButton(target: self, action: #selector(didTapLeftArrow), direction: .left)
        
        let third: CGFloat = 1/3
        
        addSubview(upArrow)
        upArrow.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        upArrow.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        upArrow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: third).isActive = true
        upArrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: third).isActive = true
        
        addSubview(rightArrow)
        rightArrow.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        rightArrow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: third).isActive = true
        rightArrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: third).isActive = true
        
        addSubview(downArrow)
        downArrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        downArrow.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        downArrow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: third).isActive = true
        downArrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: third).isActive = true
        
        addSubview(leftArrow)
        leftArrow.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        leftArrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        leftArrow.widthAnchor.constraint(equalTo: widthAnchor, multiplier: third).isActive = true
        leftArrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: third).isActive = true
    }
    
    @objc func didTapUpArrow() {
        arrowDelegate?.didTapArrow(.up)
    }
    @objc func didTapRightArrow() {
        arrowDelegate?.didTapArrow(.right)
    }
    @objc func didTapDownArrow() {
        arrowDelegate?.didTapArrow(.down)
    }
    @objc func didTapLeftArrow() {
        arrowDelegate?.didTapArrow(.left)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
