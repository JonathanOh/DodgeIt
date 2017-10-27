//
//  PoolOfPossiblePuzzles.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/26/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct PoolOfPossiblePuzzles {
    let possiblePuzzles: [TestPuzzle]
    init() {
        let path = Bundle.main.path(forResource: "LocallyStoredPuzzles", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
//        let url = URL(fileURLWithPath: "LocallyStoredPuzzles")
//        let data = try! Data(contentsOf: url)
        let puzzles = try! JSONDecoder().decode([TestPuzzle].self, from: data)
        self.possiblePuzzles = puzzles
        // do {
        //let json = try! JSONSerialization.jsonObject(with: data) as! [String:Any]
//        for entry in json["1"] as! [[String:Any]] {
//            let entryData = Data(
//            let puzzle = try! JSONDecoder().decode(Puzzle.self, from: <#T##Data#>)
//        }
//        } catch {
//
//        }
    }
}
