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

//struct TestPuzzle: Codable {
//    let difficulty: Int // value of 1-10, 1 being an easy puzzle
//    let totalWidth: Double // total width of puzzle
//    let numberOfCellsInWidth: Int // number of cells along its width
//    let numberOfCellsInHeight: Int // number of cells along its height
//    let lengthOfPuzzleCycle: Double // represents the number of seconds the explosions will cycle back
//    let safeHavens: [String:Int]
//    let obstaclePositions: [String:Int] // ["0,10", "row2"]
//    let explosionPositionAndTiming: [String:[[Int]]] // { "0,10" : [.1, .5, .9] } timings are represents in a decimal of 0-1
//
//    func isLocationSafe(_ location: String) -> Bool {
//        guard let locationExists = safeHavens[location] else { return false }
//        return locationExists == 1 ? true : false
//    }
//
//    func isLocationAnObstacle(_ location: String) -> Bool {
//        guard let locationExists = obstaclePositions[location] else { return false }
//        return locationExists == 1 ? true : false
//    }
//
//    var squareWidth: Double { // width of a single square
//        return totalWidth / Double(numberOfCellsInWidth)
//    }
//    var totalHeight: Double { // total height of puzzle
//        return squareWidth * Double(numberOfCellsInHeight)
//    }
//}
//
//struct PuzzleTestData {
//    let difficulty: Int = 1
//    let totalWidth: Double = 1 // 0-1 value that represents % of phone screen to use as width of puzzle
//    let numberOfCellsInWidth: Int = 10
//    let numberOfCellsInHeight: Int = 10
//    let lengthOfPuzzleCycle: Double = 5
//    let safeHavens: [String:Int] = ["0,9":0]
//    let obstaclePositions: [String:Int] = [
//        "0,0":1, "1,0":1, "2,0":1, "3,0":1, "4,0":1, "5,0":1, "6,0":1, "7,0":1, "8,0":1,
//        "1,9":1, "2,9":1, "3,9":1, "4,9":1, "5,9":1, "6,9":1, "7,9":1, "8,9":1, "9,9":1
//    ]//["0,9"]
//    let explosionPositionAndTiming: [Double:[[Int]]] = [
//        0.0: [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0], [0,5], [1,5], [2,5], [3,5], [4,5], [5,5], [6,5], [7,5], [8,5], [9,5]],
//        0.1: [[0,1], [1,1], [2,1], [3,1], [4,1], [5,1], [6,1], [7,1], [8,1], [9,1], [0,6], [1,6], [2,6], [3,6], [4,6], [5,6], [6,6], [7,6], [8,6], [9,6]],
//        0.2: [[0,2], [1,2], [2,2], [3,2], [4,2], [5,2], [6,2], [7,2], [8,2], [9,2], [0,7], [1,7], [2,7], [3,7], [4,7], [5,7], [6,7], [7,7], [8,7], [9,7]],
//        0.3: [[0,3], [1,3], [2,3], [3,3], [4,3], [5,3], [6,3], [7,3], [8,3], [9,3], [0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8], [9,8]],
//        0.4: [[0,4], [1,4], [2,4], [3,4], [4,4], [5,4], [6,4], [7,4], [8,4], [9,4], [0,9], [1,9], [2,9], [3,9], [4,9], [5,9], [6,9], [7,9], [8,9], [9,9]],
//        0.5: [[0,5], [1,5], [2,5], [3,5], [4,5], [5,5], [6,5], [7,5], [8,5], [9,5], [0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0]],
//        0.6: [[0,6], [1,6], [2,6], [3,6], [4,6], [5,6], [6,6], [7,6], [8,6], [9,6], [0,1], [1,1], [2,1], [3,1], [4,1], [5,1], [6,1], [7,1], [8,1], [9,1]],
//        0.7: [[0,7], [1,7], [2,7], [3,7], [4,7], [5,7], [6,7], [7,7], [8,7], [9,7], [0,2], [1,2], [2,2], [3,2], [4,2], [5,2], [6,2], [7,2], [8,2], [9,2]],
//        0.8: [[0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8], [9,8], [0,3], [1,3], [2,3], [3,3], [4,3], [5,3], [6,3], [7,3], [8,3], [9,3]],
//        0.9: [[0,9], [1,9], [2,9], [3,9], [4,9], [5,9], [6,9], [7,9], [8,9], [9,9], [0,4], [1,4], [2,4], [3,4], [4,4], [5,4], [6,4], [7,4], [8,4], [9,4]]
//    ]
//}
//struct PuzzleTestDataTwo {
//    let difficulty: Int = 1
//    let totalWidth: Double = 1 // 0-1 value that represents % of phone screen to use as width of puzzle
//    let numberOfCellsInWidth: Int = 10
//    let numberOfCellsInHeight: Int = 10
//    let lengthOfPuzzleCycle: Double = 3
//    let safeHavens: [String:Int] = [:]
//    let obstaclePositions: [String:Int] = [
//        "0,0":1, "1,0":1, "2,0":1, "3,0":1, "4,0":1, "5,0":1, "6,0":1, "7,0":1, "8,0":0, "9,0":1,
//        "0,1":0, "1,1":0, "2,1":0, "3,1":1, "4,1":0, "5,1":0, "6,1":0, "7,1":1, "8,1":0, "9,1":1,
//        "0,2":0, "1,2":1, "2,2":0, "3,2":1, "4,2":0, "5,2":1, "6,2":0, "7,2":1, "8,2":0, "9,2":1,
//        "0,3":0, "1,3":1, "2,3":0, "3,3":1, "4,3":0, "5,3":1, "6,3":0, "7,3":1, "8,3":0, "9,3":1,
//        "0,4":0, "1,4":1, "2,4":0, "3,4":1, "4,4":0, "5,4":1, "6,4":0, "7,4":1, "8,4":0, "9,4":1,
//        "0,5":0, "1,5":1, "2,5":0, "3,5":1, "4,5":0, "5,5":1, "6,5":0, "7,5":1, "8,5":0, "9,5":1,
//        "0,6":0, "1,6":1, "2,6":0, "3,6":1, "4,6":0, "5,6":1, "6,6":0, "7,6":1, "8,6":0, "9,6":1,
//        "0,7":0, "1,7":1, "2,7":0, "3,7":1, "4,7":0, "5,7":1, "6,7":0, "7,7":1, "8,7":0, "9,7":1,
//        "0,8":0, "1,8":1, "2,8":0, "3,8":0, "4,8":0, "5,8":1, "6,8":0, "7,8":0, "8,8":0, "9,8":1,
//        "0,9":0, "1,9":1, "2,9":1, "3,9":1, "4,9":1, "5,9":1, "6,9":1, "7,9":1, "8,9":1, "9,9":1
//    ]//["0,9"]
//    let explosionPositionAndTiming: [Double:[[Int]]] = [
//        0.0: [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0], [0,5], [1,5], [2,5], [3,5], [4,5], [5,5], [6,5], [7,5], [8,5], [9,5]],
//        0.1: [[0,1], [1,1], [2,1], [3,1], [4,1], [5,1], [6,1], [7,1], [8,1], [9,1], [0,6], [1,6], [2,6], [3,6], [4,6], [5,6], [6,6], [7,6], [8,6], [9,6]],
//        0.2: [[0,2], [1,2], [2,2], [3,2], [4,2], [5,2], [6,2], [7,2], [8,2], [9,2], [0,7], [1,7], [2,7], [3,7], [4,7], [5,7], [6,7], [7,7], [8,7], [9,7]],
//        0.3: [[0,3], [1,3], [2,3], [3,3], [4,3], [5,3], [6,3], [7,3], [8,3], [9,3], [0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8], [9,8]],
//        0.4: [[0,4], [1,4], [2,4], [3,4], [4,4], [5,4], [6,4], [7,4], [8,4], [9,4], [0,9], [1,9], [2,9], [3,9], [4,9], [5,9], [6,9], [7,9], [8,9], [9,9]],
//        0.5: [[0,5], [1,5], [2,5], [3,5], [4,5], [5,5], [6,5], [7,5], [8,5], [9,5], [0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0]],
//        0.6: [[0,6], [1,6], [2,6], [3,6], [4,6], [5,6], [6,6], [7,6], [8,6], [9,6], [0,1], [1,1], [2,1], [3,1], [4,1], [5,1], [6,1], [7,1], [8,1], [9,1]],
//        0.7: [[0,7], [1,7], [2,7], [3,7], [4,7], [5,7], [6,7], [7,7], [8,7], [9,7], [0,2], [1,2], [2,2], [3,2], [4,2], [5,2], [6,2], [7,2], [8,2], [9,2]],
//        0.8: [[0,8], [1,8], [2,8], [3,8], [4,8], [5,8], [6,8], [7,8], [8,8], [9,8], [0,3], [1,3], [2,3], [3,3], [4,3], [5,3], [6,3], [7,3], [8,3], [9,3]],
//        0.9: [[0,9], [1,9], [2,9], [3,9], [4,9], [5,9], [6,9], [7,9], [8,9], [9,9], [0,4], [1,4], [2,4], [3,4], [4,4], [5,4], [6,4], [7,4], [8,4], [9,4]]
//    ]
//}
///*
// "0,0": [0], "1,0": [0],"2,0": [0],"3,0": [0],"4,0": [0],"5,0": [0],"6,0": [0],"7,0": [0],"8,0": [0],"9,0": [0],
// "0,1": [0.1], "1,1": [0.1],"2,1": [0.1],"3,1": [0.1],"4,1": [0.1],"5,1": [0.1],"6,1": [0.1],"7,1": [0.1],"8,1": [0.1],"9,1": [0.1],
// "0,2": [0.2], "1,2": [0.2],"2,2": [0.2],"3,2": [0.2],"4,2": [0.2],"5,2": [0.2],"6,2": [0.2],"7,2": [0.2],"8,2": [0.2],"9,2": [0.2],
// "0,3": [0.3], "1,3": [0.3],"2,3": [0.3],"3,3": [0.3],"4,3": [0.3],"5,3": [0.3],"6,3": [0.3],"7,3": [0.3],"8,3": [0.3],"9,3": [0.3],
// "0,4": [0.4], "1,4": [0.4],"2,4": [0.4],"3,4": [0.4],"4,4": [0.4],"5,4": [0.4],"6,4": [0.4],"7,4": [0.4],"8,4": [0.4],"9,4": [0.4],
// "0,5": [0.5], "1,5": [0.5],"2,5": [0.5],"3,5": [0.5],"4,5": [0.5],"5,5": [0.5],"6,5": [0.5],"7,5": [0.5],"8,5": [0.5],"9,5": [0.5],
// "0,6": [0.6], "1,6": [0.6],"2,6": [0.6],"3,6": [0.6],"4,6": [0.6],"5,6": [0.6],"6,6": [0.6],"7,6": [0.6],"8,6": [0.6],"9,6": [0.6],
// "0,7": [0.7], "1,7": [0.7],"2,7": [0.7],"3,7": [0.7],"4,7": [0.7],"5,7": [0.7],"6,7": [0.7],"7,7": [0.7],"8,7": [0.7],"9,7": [0.7],
// "0,8": [0.8], "1,8": [0.8],"2,8": [0.8],"3,8": [0.8],"4,8": [0.8],"5,8": [0.8],"6,8": [0.8],"7,8": [0.8],"8,8": [0.8],"9,8": [0.8],
// "0,9": [0.9], "1,9": [0.9],"2,9": [0.9],"3,9": [0.9],"4,9": [0.9],"5,9": [0.9],"6,9": [0.9],"7,9": [0.9],"8,9": [0.9],"9,9": [0.9]
//
// "0,0": [0, 0.5], "1,0": [0, 0.5],"2,0": [0, 0.5],"3,0": [0, 0.5],"4,0": [0, 0.5],"5,0": [0, 0.5],"6,0": [0, 0.5],"7,0": [0, 0.5],"8,0": [0, 0.5],"9,0": [0, 0.5],
// "0,1": [0.1, 0.6], "1,1": [0.1, 0.6],"2,1": [0.1, 0.6],"3,1": [0.1, 0.6],"4,1": [0.1, 0.6],"5,1": [0.1, 0.6],"6,1": [0.1, 0.6],"7,1": [0.1, 0.6],"8,1": [0.1, 0.6],"9,1": [0.1, 0.6],
// "0,2": [0.2, 0.7], "1,2": [0.2, 0.7],"2,2": [0.2, 0.7],"3,2": [0.2, 0.7],"4,2": [0.2, 0.7],"5,2": [0.2, 0.7],"6,2": [0.2, 0.7],"7,2": [0.2, 0.7],"8,2": [0.2, 0.7],"9,2": [0.2, 0.7],
// "0,3": [0.3, 0.8], "1,3": [0.3, 0.8],"2,3": [0.3, 0.8],"3,3": [0.3, 0.8],"4,3": [0.3, 0.8],"5,3": [0.3, 0.8],"6,3": [0.3, 0.8],"7,3": [0.3, 0.8],"8,3": [0.3, 0.8],"9,3": [0.3, 0.8],
// "0,4": [0.4, 0.9], "1,4": [0.4, 0.9],"2,4": [0.4, 0.9],"3,4": [0.4, 0.9],"4,4": [0.4, 0.9],"5,4": [0.4, 0.9],"6,4": [0.4, 0.9],"7,4": [0.4, 0.9],"8,4": [0.4, 0.9],"9,4": [0.4, 0.9],
// "0,5": [0, 0.5], "1,5": [0, 0.5],"2,5": [0, 0.5],"3,5": [0, 0.5],"4,5": [0, 0.5],"5,5": [0, 0.5],"6,5": [0, 0.5],"7,5": [0, 0.5],"8,5": [0, 0.5],"9,5": [0, 0.5],
// "0,6": [0.1, 0.6], "1,6": [0.1, 0.6],"2,6": [0.1, 0.6],"3,6": [0.1, 0.6],"4,6": [0.1, 0.6],"5,6": [0.1, 0.6],"6,6": [0.1, 0.6],"7,6": [0.1, 0.6],"8,6": [0.1, 0.6],"9,6": [0.1, 0.6],
// "0,7": [0.2, 0.7], "1,7": [0.2, 0.7],"2,7": [0.2, 0.7],"3,7": [0.2, 0.7],"4,7": [0.2, 0.7],"5,7": [0.2, 0.7],"6,7": [0.2, 0.7],"7,7": [0.2, 0.7],"8,7": [0.2, 0.7],"9,7": [0.2, 0.7],
// "0,8": [0.3, 0.8], "1,8": [0.3, 0.8],"2,8": [0.3, 0.8],"3,8": [0.3, 0.8],"4,8": [0.3, 0.8],"5,8": [0.3, 0.8],"6,8": [0.3, 0.8],"7,8": [0.3, 0.8],"8,8": [0.3, 0.8],"9,8": [0.3, 0.8],
// "0,9": [0.4, 0.9], "1,9": [0.4, 0.9],"2,9": [0.4, 0.9],"3,9": [0.4, 0.9],"4,9": [0.4, 0.9],"5,9": [0.4, 0.9],"6,9": [0.4, 0.9],"7,9": [0.4, 0.9],"8,9": [0.4, 0.9],"9,9": [0.4, 0.9]
//
//
//*/




