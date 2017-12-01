//
//  Player.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/27/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

protocol UserSkillDelegate {
    func userIsNoLongerBeginner()
}
// current score, high score, lives remaining, [pool of puzzlesbyid], [completedpuzzlesbyid], current puzzle

class Player {
    //let playerID: String
    let poolOfPuzzles = PoolOfPossiblePuzzles(viewsWidth: Double(UIScreen.main.bounds.width))
    static let playerLostNotification: String = "playerLostNotification"
    var userSkillDelegate: UserSkillDelegate?
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
        didSet {
            if isUserBeginner == false {
                userSkillDelegate?.userIsNoLongerBeginner()
            }
            PlayerDefaults.shared.setIsUserBeginner(isUserBeginner)
        }
    }
    private(set) var selectedSkinID: String {
        didSet { PlayerDefaults.shared.setSelectedSkinID(selectedSkinID) }
    }
    private(set) var allUserSkins: [String] {
        didSet { PlayerDefaults.shared.setAllUserSkinsByID(allUserSkins) }
    }
    private(set) var allUserMaps: [String] {
        didSet { PlayerDefaults.shared.setAllUserMapsByID(allUserMaps) }
    }
    
    private var beginnerPuzzlesByID = [Int]()
    private(set) var randomMapTheme: MapTheme!
    
    init() {
        let playerDefaults = PlayerDefaults.shared
        self.isUserBeginner = playerDefaults.getIsUserBeginner()
        playerDefaults.setIsUserBeginner(self.isUserBeginner)
        
        self.currentScore = playerDefaults.getCurrentScore()
        self.highScore = playerDefaults.getHighScore()
        self.playerCoins = playerDefaults.getPlayerCoins()
        self.livesRemaining = playerDefaults.getLivesRemaining()
        self.completedPuzzlesByID = playerDefaults.getCompletedPuzzlesByID()
        self.selectedSkinID = playerDefaults.getSelectedSkinID()
        self.allUserSkins = playerDefaults.getAllUserSkinsByID()
        self.allUserMaps = playerDefaults.getAllUserMapsByID()
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
        self.randomMapTheme = PoolOfPossibleMapThemes.shared.getRandomUserOwnedMap()
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
        } else if difficulty < 5 {
            return 3
        } else if difficulty < 9 {
            return 6
        } else if difficulty < 14 {
            return 12
        } else {
            return 20
        }
    }
    
    func resetPlayer() {
        currentScore = 0
        livesRemaining = CONSTANTS.GAME_DEFAULTS.LIVES
        
        setNewMapTheme()
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
    
    func setSelectedSkinByID(_ id: String) {
        // Check if user has the skin, once found, set it.
        for skin in allUserSkins {
            if skin == id {
                selectedSkinID = id
            }
        }
    }
    
    func playerDidPurchaseSkin(_ character: Character, wasRealMoneyPurchase: Bool) {
        allUserSkins += [character.character_id]
        if !wasRealMoneyPurchase {
            playerCoins -= character.coinCost
        }
    }
    
    func syncPlayerDefaults() {
        PlayerDefaults.shared.setCurrentScoreTo(currentScore)
        PlayerDefaults.shared.setHighScore(highScore)
        PlayerDefaults.shared.setLivesRemaining(livesRemaining)
        PlayerDefaults.shared.setPoolOfPuzzlesByID(poolOfPuzzlesByID)
        PlayerDefaults.shared.setCompletedPuzzlesByID(completedPuzzlesByID)
        PlayerDefaults.shared.setPlayerCoins(playerCoins)
        PlayerDefaults.shared.setIsUserBeginner(isUserBeginner)
        PlayerDefaults.shared.setSelectedSkinID(selectedSkinID)
        PlayerDefaults.shared.setAllUserSkinsByID(allUserSkins)
        PlayerDefaults.shared.setAllUserMapsByID(allUserMaps)
    }
    
}


