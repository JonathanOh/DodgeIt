//
//  PlayerDefaults.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/20/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

class PlayerDefaults {
    static let shared = PlayerDefaults()
    private let defaults = UserDefaults.standard
    private init() {}

    func getCurrentScore() -> Int {
        return defaults.object(forKey: "current_score") as? Int ?? 0
    }
    func setCurrentScoreTo(_ value: Int) {
        defaults.set(value, forKey: "current_score")
    }
    
    func getHighScore() -> Int {
        return defaults.object(forKey: "high_score") as? Int ?? 0
    }
    func setHighScore(_ value: Int) {
        defaults.set(value, forKey: "high_score")
    }
    
    func getLivesRemaining() -> Int {
        return defaults.object(forKey: "lives_remaining") as? Int ?? CONSTANTS.GAME_DEFAULTS.LIVES
    }
    func setLivesRemaining(_ value: Int) {
        defaults.set(value, forKey: "lives_remaining")
    }
    
    func getPoolOfPuzzlesByID() -> [Int] {
        return defaults.object(forKey: "pool_of_puzzles_by_id") as? [Int] ?? []
    }
    func setPoolOfPuzzlesByID(_ value: [Int]) {
        defaults.set(value, forKey: "pool_of_puzzles_by_id")
    }
    
    func getCompletedPuzzlesByID() -> [Int] {
        return defaults.object(forKey: "completed_puzzles_by_id") as? [Int] ?? []
    }
    func setCompletedPuzzlesByID(_ value: [Int]) {
        defaults.set(value, forKey: "completed_puzzles_by_id")
    }
    
    func getPlayerCoins() -> Int {
        return defaults.object(forKey: "player_coins") as? Int ?? 0
    }
    func setPlayerCoins(_ value: Int) {
        defaults.set(value, forKey: "player_coins")
    }
    
    func getIsUserBeginner() -> Bool {
        return defaults.object(forKey: "isUserBeginner") as? Bool ?? true
    }
    func setIsUserBeginner(_ value: Bool) {
        defaults.set(value, forKey: "isUserBeginner")
    }
    
    func getSelectedSkinID() -> String {
        return defaults.object(forKey: "selected_skin") as? String ?? CONSTANTS.CHARACTERS.DEFAULT
    }
    func setSelectedSkinID(_ value: String) {
        defaults.set(value, forKey: "selected_skin")
    }
    
    func getAllUserSkinsByID() -> [String] {
        return defaults.object(forKey: "all_user_skins") as? [String] ?? [CONSTANTS.CHARACTERS.DEFAULT]
    }
    func setAllUserSkinsByID(_ value: [String]) {
        defaults.set(value, forKey: "all_user_skins")
    }
    func getAllUserMapsByID() -> [String] {
        return defaults.object(forKey: "all_user_maps") as? [String] ?? ["1","2"]
    }
    func setAllUserMapsByID(_ value: [String]) {
        defaults.set(value, forKey: "all_user_maps")
    }
    func userViewedGameInstructions() -> Bool {
        return defaults.object(forKey: "userViewedGameInstructions") as? Bool ?? false
    }
    func setUserDidViewGameInstructions() {
        defaults.set(true, forKey: "userViewedGameInstructions")
    }
}
