//
//  String+TupleValue.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

extension String {
    func tupleValue() -> (Int, Int) {
        let spacesRemoved = self.filter { $0 != " " }
        let stringArray = spacesRemoved.components(separatedBy: ",")
        return (Int(stringArray.first!)!, Int(stringArray.last!)!)
    }
}
