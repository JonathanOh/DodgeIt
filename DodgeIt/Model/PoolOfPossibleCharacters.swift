//
//  PoolOfPossibleCharacters.swift
//  DodgeIt
//
//  Created by admin on 11/19/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

class PoolOfPossibleCharacters {
    static let shared = PoolOfPossibleCharacters()
    
    let allPossibleCharacters: [Character]
    private var dictionaryOfAllCharacters = [String:Character]()
    
    private init() {
        let path = Bundle.main.path(forResource: "Characters", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let characters = try! JSONDecoder().decode([Character].self, from: data)
        self.allPossibleCharacters = characters
        _ = characters.map { dictionaryOfAllCharacters[$0.character_id] = $0 }
    }
    
    func getCharacterByID(_ id: String) -> Character? {
        return dictionaryOfAllCharacters[id] ?? nil
    }
    
}
