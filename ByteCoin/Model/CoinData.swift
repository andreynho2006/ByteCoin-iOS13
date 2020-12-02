//
//  CoinData.swift
//  ByteCoin
//
//  Created by Andrei Cirlan on 02.12.2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let rate: Double
    let asset_id_base: String
    let asset_id_quote: String
}
