//
//  String+TupleValue.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

extension String {
    func tupleValue() -> (Int, Int)? {
        let spacesRemoved = self.filter { $0 != " " }
        let stringArray = spacesRemoved.components(separatedBy: ",")
        if stringArray.count != 2 { return nil }
        guard let firstValue = stringArray.first,
            let secondValue = stringArray.last,
            let firstInteger = Int(firstValue),
            let secondInteger = Int(secondValue) else { return nil }
        if firstInteger < 0 || secondInteger < 0 { return nil }
        return (firstInteger, secondInteger)
    }
}
