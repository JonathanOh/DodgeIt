//
//  PuzzleView.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    let currentPuzzle: Puzzle
    let gridContainerView: GridContainerView
    
    init(currentPuzzle: Puzzle) {
        self.currentPuzzle = currentPuzzle
        self.gridContainerView = GridContainerView(currentPuzzle: currentPuzzle)
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 100/255.0, green: 1.0, blue: 100/255.0, alpha: 1)
        setupContainerViewWith(puzzle: currentPuzzle)
    }
    
    func setupContainerViewWith(puzzle: Puzzle) {
        addSubview(gridContainerView)
        gridContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gridContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gridContainerView.widthAnchor.constraint(equalToConstant: CGFloat(puzzle.totalWidth)).isActive = true
        gridContainerView.heightAnchor.constraint(equalToConstant: CGFloat(puzzle.totalHeight)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
