//
//  PoolOfPossibleMapThemes.swift
//  DodgeIt
//
//  Created by admin on 11/23/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

class PoolOfPossibleMapThemes {
    static let shared = PoolOfPossibleMapThemes()
    
    private var allPossibleMaps = [MapThemeNew]()
    private var dictionaryOfAllMaps = [String:MapThemeNew]()
    
    private init() {
        let path = Bundle.main.path(forResource: "MapThemes", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let maps = try! JSONDecoder().decode([MapThemeNew].self, from: data)
        self.allPossibleMaps = maps
        _ = maps.map { dictionaryOfAllMaps[$0.id] = $0 }
    }
    
    func getMapByID(_ id: String) -> MapThemeNew {
        return dictionaryOfAllMaps[id] ?? dictionaryOfAllMaps["1"]!
    }
    
    func getAllUserOwnedMaps() -> [MapThemeNew] {
        let userOwnedMapsByStringID = PlayerDefaults.shared.getAllUserMapsByID()
        let userOwnedMaps = userOwnedMapsByStringID.map { getMapByID($0) }
        return userOwnedMaps
    }
    
    func getRandomUserOwnedMap() -> MapThemeNew {
        let allUserMaps = getAllUserOwnedMaps()
        return allUserMaps[Int.randomUpTo(allUserMaps.count)]
    }
    
    func getAllMapsUserDoesNotHave() -> [MapThemeNew] {
        let userOwnedMapsByStringID = PlayerDefaults.shared.getAllUserMapsByID()
        var copyOfDictionaryOfAllMaps = dictionaryOfAllMaps
        //Remove owned mapss from dictionary
        for ownedMap in userOwnedMapsByStringID {
            copyOfDictionaryOfAllMaps[ownedMap] = nil
        }
        //Collect all the key values which are the IDs of all maps
        var unownedMapsByStringID = [String]()
        for (key, _) in copyOfDictionaryOfAllMaps {
            if copyOfDictionaryOfAllMaps[key] != nil {
                unownedMapsByStringID.append(key)
            }
        }
        let maps = unownedMapsByStringID.map { getMapByID($0) }
        return maps
    }
}

