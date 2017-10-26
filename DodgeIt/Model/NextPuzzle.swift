//
//  NextPuzzle.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/26/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

struct NextPuzzle {
    let puzzle: Puzzle
    let puzzleView: PuzzleView
    let squareData: SquareData
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
        self.puzzleView = PuzzleView(currentPuzzle: puzzle)
        self.squareData = SquareData(matrix: self.puzzleView.gridContainerView.squareData.matrix)
    }
}
