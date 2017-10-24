//
//  PlayerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/24/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    let widthOfPuzzleSquare: CGFloat
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    
    init(skin: UIColor, playerSize: Int, position: CGPoint, widthOfPuzzleSquare: Double) {
        self.widthOfPuzzleSquare = CGFloat(widthOfPuzzleSquare)
        let width = widthOfPuzzleSquare * Double(playerSize)
        let height = widthOfPuzzleSquare * Double(playerSize)
        super.init(frame: CGRect(x: Double(position.x), y: Double(position.y), width: width, height: height))
        backgroundColor = skin
        layer.cornerRadius = frame.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: UISwipeGestureRecognizerDirection) {
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let weakSelf = self else { return }
            switch direction {
            case .up:
                weakSelf.center = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y - weakSelf.widthOfPuzzleSquare)
            case .right:
                weakSelf.center = CGPoint(x: weakSelf.center.x + weakSelf.widthOfPuzzleSquare, y: weakSelf.center.y)
            case .down:
                weakSelf.center = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y + weakSelf.widthOfPuzzleSquare)
            case .left:
                weakSelf.center = CGPoint(x: weakSelf.center.x - weakSelf.widthOfPuzzleSquare, y: weakSelf.center.y)
            default:
                return
            }
        }
    }
}
