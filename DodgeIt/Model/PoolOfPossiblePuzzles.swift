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
    
    private var possiblePuzzles: [Puzzle]
    private var puzzleLookupByID = [String:Puzzle]()
    
//    func getRandomPuzzleByDifficulty(_ difficulty: Difficulty) -> Puzzle {
//        
//    }
    
    func getPuzzleByID(_ id: Int) -> Puzzle {
        if let puzzleExists = puzzleLookupByID[String(id)] {
            return puzzleExists
        } else {
            return getRandomPuzzle()
        }
    }
    func getRandomPuzzle() -> Puzzle {
        let randomNum = Int(arc4random_uniform(UInt32(possiblePuzzles.count)))
        if TEST.IS_TEST_MODE {
            for puzzle in possiblePuzzles {
                if puzzle.puzzleID == TEST.PUZZLE_ID {
                    return puzzle
                } else {
                    print("could not find puzzle ID \(TEST.PUZZLE_ID)")
                }
            }
        }
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
    }
}
