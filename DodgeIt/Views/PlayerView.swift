//
//  PlayerView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/24/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    let puzzle: Puzzle
    let startingLocation: CGPoint
    let swipeDirections: [UISwipeGestureRecognizerDirection] = [.up, .right, .down, .left]
    weak private var boundingView: UIView?
    
    init(skin: UIColor, playerSize: Int, puzzle: Puzzle, boundingView: UIView) {
        self.boundingView = boundingView
        self.puzzle = puzzle
        let width = puzzle.squareWidth * Double(playerSize)
        let height = puzzle.squareWidth * Double(playerSize)
        self.startingLocation = CGPoint(x: boundingView.center.x + CGFloat(puzzle.squareWidth/2), y: boundingView.center.y + CGFloat(puzzle.squareWidth/2) + CGFloat(puzzle.squareWidth * 7))
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)))
        center = startingLocation
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
                let newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y - CGFloat(weakSelf.puzzle.squareWidth))
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .right:
                let newCenter = CGPoint(x: weakSelf.center.x + CGFloat(weakSelf.puzzle.squareWidth), y: weakSelf.center.y)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .down:
                let newCenter = CGPoint(x: weakSelf.center.x, y: weakSelf.center.y + CGFloat(weakSelf.puzzle.squareWidth))
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            case .left:
                let newCenter = CGPoint(x: weakSelf.center.x - CGFloat(weakSelf.puzzle.squareWidth), y: weakSelf.center.y)
                if parentView.point(inside: newCenter, with: nil) { weakSelf.center = newCenter }
            default:
                return
            }
        }
    }
}
