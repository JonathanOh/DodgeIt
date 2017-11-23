//
//  Character.swift
//  DodgeIt
//
//  Created by admin on 11/19/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation

struct Character: Codable {
    let character_id: String
    let character_name: String
    let product_id: String
    let right_facing_asset_name_literal: String
    let number_of_images: Int
    let yOffsetConstant: Int
    let widthMultiplier: Double
    let heightMultiplier: Double
    let coinCost: Int
    let moneyCost: String
}
