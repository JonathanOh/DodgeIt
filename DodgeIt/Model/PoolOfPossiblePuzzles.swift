//
//  PoolOfPossiblePuzzles.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/26/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct PoolOfPossiblePuzzles {
    var possiblePuzzles: [Puzzle]
    init(viewsWidth: Double) {
        let path = Bundle.main.path(forResource: "LocallyStoredPuzzles", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let puzzles = try! JSONDecoder().decode([Puzzle].self, from: data)
        self.possiblePuzzles = puzzles
        _ = possiblePuzzles.map { $0.updateTotalWidth(viewsWidth) }
    }
}
