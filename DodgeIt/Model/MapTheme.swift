//
//  MapTheme.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/15/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

struct MapTheme: Codable {
    let description: String
    let id: String
    let backgroundColor: [Int]
    let courseColor: [Int] // Typically same as backgroundColor
    let labelColors: [Int]
    let obstacleColor: [Int]
    let explosionColor: [Int]
    let isPaidTheme: Bool
}