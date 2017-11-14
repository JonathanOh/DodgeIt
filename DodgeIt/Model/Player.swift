//
//  Player.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/27/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

// userdefault saves
// current score, high score, lives remaining, [pool of puzzlesbyid], [completedpuzzlesbyid], current puzzle

class Player {
    //let playerID: String
    let poolOfPuzzles = PoolOfPossiblePuzzles(viewsWidth: Double(UIScreen.main.bounds.width))
    static let playerLostNotification: String = "playerLostNotification"
    private(set) var currentScore: Int {
        didSet {
            UserDefaults.standard.set(currentScore, forKey: "current_score")
        }
    }
    private(set) var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "high_score")
        }
    }
    private(set) var livesRemaining: Int {
        didSet {
            UserDefaults.standard.set(livesRemaining, forKey: "lives_remaining")
        }
    }
    private var poolOfPuzzlesByID = [Int]() {
        didSet {
            UserDefaults.standard.set(poolOfPuzzlesByID, forKey: "pool_of_puzzles_by_id")
        }
    }
    private var completedPuzzlesByID = [Int]() {
        didSet {
            UserDefaults.standard.set(completedPuzzlesByID, forKey: "completed_puzzles_by_id")
        }
    }
    init() {
//        //currentScore: PlayerDummyData.currentScore, highScore: PlayerDummyData.highScore, livesRemaining: PlayerDummyData.livesRemaining, poolOfPuzzlesByID: poolOfPossiblePuzzles.possiblePuzzles, completedPuzzlesByID: []
//        self.currentScore = PlayerDummyData.currentScore
//        self.highScore = PlayerDummyData.highScore
//        self.livesRemaining = PlayerDummyData.livesRemaining
//        _ = poolOfPuzzles.possiblePuzzles.map { self.poolOfPuzzlesByID.append($0.puzzleID) }
//        self.poolOfPuzzlesByID.shuffle()
//        self.completedPuzzlesByID = []
//        /*
//         if we have userDefaults, set users stuff
//         else
//         set all to 0
//         */
        if let savedCurrentScore = UserDefaults.standard.object(forKey: "current_score") as? Int,
        let savedHighScore = UserDefaults.standard.object(forKey: "high_score") as? Int,
        let savedLivesRemaining = UserDefaults.standard.object(forKey: "lives_remaining") as? Int,
        let savedPoolOfPuzzlesByID = UserDefaults.standard.object(forKey: "pool_of_puzzles_by_id") as? [Int],
        let savedCompletedPuzzlesByID = UserDefaults.standard.object(forKey: "completed_puzzles_by_id") as? [Int] {
            self.currentScore = savedCurrentScore
            self.highScore = savedHighScore
            self.livesRemaining = savedLivesRemaining
            self.poolOfPuzzlesByID = savedPoolOfPuzzlesByID
            self.completedPuzzlesByID = savedCompletedPuzzlesByID
        } else {
            self.currentScore = 0
            self.highScore = 0
            self.livesRemaining = CONSTANTS.GAME_DEFAULTS.LIVES
            _ = poolOfPuzzles.possiblePuzzles.map { self.poolOfPuzzlesByID.append($0.puzzleID) }
            self.poolOfPuzzlesByID.shuffle()
            self.completedPuzzlesByID = []
        }
    }
    
    func getNextLevelByID() -> Int {
        if poolOfPuzzlesByID.count <= 0 {
            poolOfPuzzlesByID = completedPuzzlesByID.shuffled()
            completedPuzzlesByID = []
        }
        return poolOfPuzzlesByID.last!
    }
    func playerCompletedCurrent(puzzle: Puzzle) {
        increasePlayerScoreBy(puzzle.difficulty * 100)
        completedPuzzlesByID.append(poolOfPuzzlesByID.last!)
        poolOfPuzzlesByID.removeLast()
    }
    func resetPlayer() {
        currentScore = 0
        livesRemaining = CONSTANTS.GAME_DEFAULTS.LIVES
        poolOfPuzzlesByID += completedPuzzlesByID
        poolOfPuzzlesByID.shuffle()
        completedPuzzlesByID = []
    }
    func playerDied() {
//        if playerLost() {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Player.playerLostNotification), object: nil)
//            return
//        }
        livesRemaining -= 1
    }
    func playerLost() -> Bool {
        return livesRemaining <= 1
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


