//
//  Player.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/27/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class Player {
    //let playerID: String
    static let playerLostNotification: String = "playerLostNotification"
    private(set) var currentScore: Int
    private(set) var highScore: Int
    private(set) var livesRemaining: Int
    private var poolOfPuzzlesByID = [Int]()
    private var completedPuzzlesByID = [Int]()
    init(currentScore: Int, highScore: Int, livesRemaining: Int, poolOfPuzzlesByID: [Puzzle], completedPuzzlesByID: [Int]) {
        self.currentScore = currentScore
        self.highScore = highScore
        self.livesRemaining = livesRemaining
        _ = poolOfPuzzlesByID.map { self.poolOfPuzzlesByID.append($0.puzzleID) }
        self.completedPuzzlesByID = completedPuzzlesByID
    }
    
    func getNextLevelByID() -> Int {
        if poolOfPuzzlesByID.count <= 0 {
            poolOfPuzzlesByID = completedPuzzlesByID
            completedPuzzlesByID = []
        }
        return poolOfPuzzlesByID.last!
    }
    func playerCompletedCurrent(puzzle: Puzzle) {
        increasePlayerScoreBy(puzzle.difficulty * 100)
        completedPuzzlesByID.append(poolOfPuzzlesByID.last!)
        poolOfPuzzlesByID.removeLast()
    }
    func playerDied() {
        if playerLost() {
            currentScore = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Player.playerLostNotification), object: nil)
            return
        }
        livesRemaining -= 1
    }
    func playerLost() -> Bool {
        return livesRemaining <= 0
    }
    func increasePlayerScoreBy(_ puzzleScore: Int) {
        currentScore += puzzleScore
        if highScore < currentScore {
            highScore = currentScore
        }
    }
    func getPlayerHighScore() -> Int {
        return highScore
    }
    
}


