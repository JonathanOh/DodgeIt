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
    weak private var boundingView: UIView?
    
    init(skin: UIColor, playerSize: Int, position: CGPoint, widthOfPuzzleSquare: Double, boundingView: UIView) {
        self.widthOfPuzzleSquare = CGFloat(widthOfPuzzleSquare)
        self.boundingView = boundingView
        let width = widthOfPuzzleSquare * Double(playerSize)
        let height = widthOfPuzzleSquare * Double(playerSize)
        //super.init(frame: CGRect(x: Double(position.x), y: Double(position.y), width: width, height: height))
        super.init(frame: CGRect(origin: position, size: CGSize(width: width, height: height)))
        backgroundColor = skin
        layer.cornerRadius = frame.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: UISwipeGestureRecognizerDirection) {
        guard let parentView = boundingView else { return }
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let weakSelf = self else { return }
            switch direction {
            case .up:
                let newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y - weakSelf.widthOfPuzzleSquare)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .right:
                let newCenter = CGPoint(x: weakSelf.center.x + weakSelf.widthOfPuzzleSquare, y: weakSelf.center.y)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .down:
                let newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y + weakSelf.widthOfPuzzleSquare)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .left:
                let newCenter = CGPoint(x: weakSelf.center.x - weakSelf.widthOfPuzzleSquare, y: weakSelf.center.y)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            default:
                return
            }
        }
    }
}
