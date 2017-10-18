//
//  Puzzle.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct Puzzle {
    let difficulty: Int // value of 1-10, 1 being an easy puzzle
    let totalWidth: Double // total width of puzzle
    let numberOfCellsInWidth: Int // number of cells along its width
    let numberOfCellsInHeight: Int // number of cells along its height
    let lengthOfPuzzleCycle: Int // represents the number of seconds the explosions will cycle back
    let obstaclePositions: [String] // ["0,10", "row2"]
    let explosionPositionAndTiming: [String:[Double]] // { "0,10" : [.1, .5, .9] } timings are represents in a decimal of 0-1
}

struct PuzzleTestData {
    let difficulty: Int = 1
    let totalWidth: Double = 1 // 0-1 value that represents % of phone screen to use as width of puzzle
    let numberOfCellsInWidth: Int = 10
    let numberOfCellsInHeight: Int = 10
    let lengthOfPuzzleCycle: Int = 3
    let obstaclePositions: [String] = ["0,10"]
    let explosionPositionAndTiming: [String:[Double]] = ["0,5": [0.5]]
}
