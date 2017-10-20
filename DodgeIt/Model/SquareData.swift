//
//  SquareData.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 10/19/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct SquareData {
    let matrix: [[SquareView]]
    private var dictionary = [String:SquareView]()
    
    init(matrix: [[SquareView]]) {
        self.matrix = matrix
        _ = matrix.map { $0.map { dictionary[SquareData.tupleString($0.location)] = $0 } }
    }
    
    func getSingleSquare(_ location: (x: Int, y: Int)) -> SquareView? {
        if matrix.count < 1 { return nil }
        if matrix[0].count < 1 { return nil }
        if location.x > matrix[0].count - 1 { return nil }
        if location.y > matrix.count - 1 { return nil }
        guard let square = dictionary[SquareData.tupleString(location)] else { return nil }
        return square
    }
    func getSquaresAt(_ locations: [(Int, Int)]) -> [SquareView?] {
        return locations.map { getSingleSquare($0) }
    }
    static func tupleString(_ tuple: (Int, Int)) -> String {
        return "\(tuple.0),\(tuple.1)"
    }
}
