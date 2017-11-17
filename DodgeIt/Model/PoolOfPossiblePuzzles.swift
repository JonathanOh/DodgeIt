//
//  PoolOfPossiblePuzzles.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/26/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct PoolOfPossiblePuzzles {
    enum Difficulty {
        case veryEasy
        case easy
        case medium
        case hard
        case veryHard
    }
    
    private(set) var beginnerPuzzles: [Puzzle]
    private var beginnerPuzzleLookupByID = [String:Puzzle]()
    
    private(set) var possiblePuzzles: [Puzzle]
    private var puzzleLookupByID = [String:Puzzle]()
    
//    func getRandomPuzzleByDifficulty(_ difficulty: Difficulty) -> Puzzle {
//        
//    }
    func getBeginnerPuzzleByID(_ id: Int) -> Puzzle {
        if let puzzleExists = beginnerPuzzleLookupByID[String(id)] {
            return puzzleExists
        } else {
            print("could not find puzzle ID \(TEST.PUZZLE_ID). Serving first beginner puzzle.")
            return beginnerPuzzles[0]
        }
    }
    
    func getPuzzleByID(_ id: Int) -> Puzzle {
        if let puzzleExists = puzzleLookupByID[String(id)] {
            return puzzleExists
        } else {
            print("could not find puzzle ID \(TEST.PUZZLE_ID). Serving random puzzle.")
            return getRandomPuzzle()
        }
    }
    func getRandomPuzzle() -> Puzzle {
        if TEST.IS_TEST_MODE {
            return getPuzzleByID(TEST.PUZZLE_ID)
        }
        let randomNum = Int(arc4random_uniform(UInt32(possiblePuzzles.count)))
        return possiblePuzzles[randomNum]
    }
    
    init(viewsWidth: Double) {
        let path = Bundle.main.path(forResource: "LocallyStoredPuzzles", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let puzzles = try! JSONDecoder().decode([Puzzle].self, from: data)
        self.possiblePuzzles = puzzles
        for puzzle in self.possiblePuzzles {
            puzzle.updateTotalWidth(viewsWidth)
            puzzleLookupByID[String(puzzle.puzzleID)] = puzzle
        }
        
        let begginerPath = Bundle.main.path(forResource: "LocallyStoredBeginnersPuzzles", ofType: "json")
        let beginnerData = try! Data(contentsOf: URL(fileURLWithPath: begginerPath!))
        let beginnerPuzzles = try! JSONDecoder().decode([Puzzle].self, from: beginnerData)
        self.beginnerPuzzles = beginnerPuzzles
        for puzzle in self.beginnerPuzzles {
            puzzle.updateTotalWidth(viewsWidth)
            beginnerPuzzleLookupByID[String(puzzle.puzzleID)] = puzzle
        }
    }
}
