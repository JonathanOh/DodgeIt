//
//  Player.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/27/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

// current score, high score, lives remaining, [pool of puzzlesbyid], [completedpuzzlesbyid], current puzzle

class Player {
    //let playerID: String
    let poolOfPuzzles = PoolOfPossiblePuzzles(viewsWidth: Double(UIScreen.main.bounds.width))
    static let playerLostNotification: String = "playerLostNotification"
    private(set) var currentScore: Int {
        didSet { PlayerDefaults.shared.setCurrentScoreTo(currentScore) }
    }
    private(set) var highScore: Int {
        didSet { PlayerDefaults.shared.setHighScore(highScore) }
    }
    private(set) var livesRemaining: Int {
        didSet { PlayerDefaults.shared.setLivesRemaining(livesRemaining) }
    }
    private var poolOfPuzzlesByID: [Int] {
        didSet { PlayerDefaults.shared.setPoolOfPuzzlesByID(poolOfPuzzlesByID) }
    }
    private var completedPuzzlesByID = [Int]() {
        didSet { PlayerDefaults.shared.setCompletedPuzzlesByID(completedPuzzlesByID) }
    }
    private(set) var playerCoins: Int {
        didSet { PlayerDefaults.shared.setPlayerCoins(playerCoins) }
    }
    private(set) var isUserBeginner: Bool {
        didSet { PlayerDefaults.shared.setIsUserBeginner(isUserBeginner) }
    }
    private var beginnerPuzzlesByID = [Int]()
    let mapThemes: [MapTheme]
    private(set) var randomMapTheme: MapTheme!

    init() {
        let mapPath = Bundle.main.path(forResource: "LocallyStoredMapThemes", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: mapPath!))
        self.mapThemes = try! JSONDecoder().decode([MapTheme].self, from: data)
        
        let playerDefaults = PlayerDefaults.shared
        self.isUserBeginner = playerDefaults.getIsUserBeginner()
        playerDefaults.setIsUserBeginner(self.isUserBeginner)
        
        self.currentScore = playerDefaults.getCurrentScore()
        self.highScore = playerDefaults.getHighScore()
        self.playerCoins = playerDefaults.getPlayerCoins()
        self.livesRemaining = playerDefaults.getLivesRemaining()
        self.completedPuzzlesByID = playerDefaults.getCompletedPuzzlesByID()
        if playerDefaults.getPoolOfPuzzlesByID().isEmpty {
            var puzzleIDs = [Int]()
            _ = poolOfPuzzles.possiblePuzzles.map { puzzleIDs.append($0.puzzleID) }
            puzzleIDs.shuffle()
            self.poolOfPuzzlesByID = puzzleIDs
        } else {
            self.poolOfPuzzlesByID = playerDefaults.getPoolOfPuzzlesByID()
        }
        
        if self.isUserBeginner {
            _ = poolOfPuzzles.beginnerPuzzles.map { self.beginnerPuzzlesByID.append($0.puzzleID) }
        }
        setNewMapTheme()
        syncPlayerDefaults()
    }
    
    func setNewMapTheme() {
        let randomNumber = arc4random_uniform(UInt32(self.mapThemes.count))
        self.randomMapTheme = self.mapThemes[Int(randomNumber)]
    }
    
    func getNextLevelByID() -> Int {
        if TEST.USER_IS_BEGINNER { return TEST.BEGGINNER_PUZZLE_ID }
        if TEST.IS_TEST_MODE { return TEST.PUZZLE_ID }
        
        if !beginnerPuzzlesByID.isEmpty {
            return beginnerPuzzlesByID.first!
        }
        
        if poolOfPuzzlesByID.count <= 0 {
            _ = poolOfPuzzles.possiblePuzzles.map { self.poolOfPuzzlesByID.append($0.puzzleID) }
            poolOfPuzzlesByID.shuffle()
            completedPuzzlesByID = []
        }
        return poolOfPuzzlesByID.last!
    }
    
    func playerObtainedCoins(_ numberOfCoins: Int = 1) {
        playerCoins += numberOfCoins
    }
    
    @discardableResult
    func playerSpentCoins(_ numberOfCoins: Int) -> Bool {
        if playerCoins < numberOfCoins { return false }
        playerCoins -= numberOfCoins
        return true
    }
    
    func playerCompletedCurrent(puzzle: Puzzle) {
        playerObtainedCoins(numberOfCoinsToAwardBasedOnDifficulty(puzzle.difficulty))
        setNewMapTheme()
        increasePlayerScoreBy(puzzle.difficulty)
        
        if TEST.IS_TEST_MODE { return }
        if isUserBeginner {
            beginnerPuzzlesByID.removeFirst()
            if beginnerPuzzlesByID.isEmpty {
                isUserBeginner = false
            }
            return
        }
        
        completedPuzzlesByID.append(poolOfPuzzlesByID.last!)
        poolOfPuzzlesByID.removeLast()
    }
    
    func numberOfCoinsToAwardBasedOnDifficulty(_ difficulty: Int) -> Int {
        if difficulty < 3 {
            return 1
        } else if difficulty < 6 {
            return 2
        } else if difficulty < 9 {
            return 3
        } else {
            return 5
        }
    }
    
    func resetPlayer() {
        currentScore = 0
        livesRemaining = CONSTANTS.GAME_DEFAULTS.LIVES
        
        poolOfPuzzlesByID = []
        _ = poolOfPuzzles.possiblePuzzles.map { self.poolOfPuzzlesByID.append($0.puzzleID) }
        poolOfPuzzlesByID.shuffle()
        completedPuzzlesByID = []
        
        //Restore beginner puzzles
        if isUserBeginner {
            self.beginnerPuzzlesByID = []
            _ = poolOfPuzzles.beginnerPuzzles.map { self.beginnerPuzzlesByID.append($0.puzzleID) }
        }
    }
    func playerDied() {
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
    
    func syncPlayerDefaults() {
        PlayerDefaults.shared.setCurrentScoreTo(currentScore)
        PlayerDefaults.shared.setHighScore(highScore)
        PlayerDefaults.shared.setLivesRemaining(livesRemaining)
        PlayerDefaults.shared.setPoolOfPuzzlesByID(poolOfPuzzlesByID)
        PlayerDefaults.shared.setCompletedPuzzlesByID(completedPuzzlesByID)
        PlayerDefaults.shared.setPlayerCoins(playerCoins)
        PlayerDefaults.shared.setIsUserBeginner(isUserBeginner)
    }
    
}


