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
    
    func getAllUserOwnedCharacters() -> [Character] {
        let userOwnedCharactersByStringID = PlayerDefaults.shared.getAllUserSkinsByID()
        let userOwnedCharacters = userOwnedCharactersByStringID.map { getCharacterByID($0)! }
        return userOwnedCharacters
    }
    
    func getAllCharactersUserDoesNotHave() -> [Character] {
        let userOwnedCharactersByStringID = PlayerDefaults.shared.getAllUserSkinsByID()
        var copyOfDictionaryOfAllCharacters = dictionaryOfAllCharacters
        //Remove owned characters from dictionary
        for ownedCharacter in userOwnedCharactersByStringID {
            copyOfDictionaryOfAllCharacters[ownedCharacter] = nil
        }
        //Collect all the key values which are the IDs of all characters
        var unownedCharactersByStringID = [String]()
        for (key, _) in copyOfDictionaryOfAllCharacters {
            if copyOfDictionaryOfAllCharacters[key] != nil {
                unownedCharactersByStringID.append(key)
            }
        }
        let characters = unownedCharactersByStringID.map { getCharacterByID($0)! }
        return characters
    }
    
}
