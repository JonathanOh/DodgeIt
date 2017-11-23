//
//  Puzzle.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

class Puzzle: Codable {
    let puzzleID: Int
    let difficulty: Int // value of 1-10, 1 being an easy puzzle
    var totalWidth: Double // total width of puzzle
    let numberOfCellsInWidth: Int // number of cells along its width
    let numberOfCellsInHeight: Int // number of cells along its height
    let lengthOfPuzzleCycle: Double // represents the number of seconds the explosions will cycle back
    let gemPositions: [String:Int]
    let safeHavens: [String:Int]
    let obstaclePositions: [String:Int] // ["0,10", "row2"]
    let explosionPositionAndTiming: [String:[[Int]]] // { "0,10" : [.1, .5, .9] } timings are represents in a decimal of 0-1
    
    func isLocationSafe(_ location: String) -> Bool {
        guard let locationExists = safeHavens[location] else { return false }
        return locationExists == 1 ? true : false
    }
    
    func isLocationAnObstacle(_ location: String) -> Bool {
        guard let locationExists = obstaclePositions[location] else { return false }
        return locationExists == 1 ? true : false
    }
    
    func isLocationAGem(_ location: String) -> Bool {
        guard let locationExists = gemPositions[location] else { return false }
        return locationExists == 1 ? true : false
    }
    
    func updateTotalWidth(_ screenWidth: Double) {
        self.totalWidth = self.totalWidth * screenWidth
    }
    
    var squareWidth: Double { // width of a single square
        return totalWidth / Double(numberOfCellsInWidth)
    }
    var totalHeight: Double { // total height of puzzle
        return squareWidth * Double(numberOfCellsInHeight)
    }
}
