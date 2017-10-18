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
        backgroundColor = .orange
        setupContainerViewWith(puzzle: currentPuzzle)
    }
    
    func setupContainerViewWith(puzzle: Puzzle) {
        let width: CGFloat = CGFloat(puzzle.totalWidth)
        let squareWidth: CGFloat = width / CGFloat(puzzle.numberOfCellsInWidth)
        let height: CGFloat = CGFloat(puzzle.numberOfCellsInHeight) * squareWidth
        addSubview(gridContainerView)
        gridContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gridContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gridContainerView.widthAnchor.constraint(equalToConstant: width).isActive = true
        gridContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
