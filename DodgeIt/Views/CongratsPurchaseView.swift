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
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        addGestureRecognizer(tapGestureRecognizer)
        
        backgroundColor = .black
        alpha = 0
    }
    
    @objc func didTapScreen() {
        removeFromSuperview()
    }
    
    func triggerAnimation() {
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.alpha = 0.75
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
