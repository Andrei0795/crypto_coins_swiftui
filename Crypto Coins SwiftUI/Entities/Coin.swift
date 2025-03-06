//
//  Coin.swift
//  Crypto Coins SwiftUI
//
//  Created by Andrei Ionescu on 06.03.2025.
//

import Foundation

struct CoinStore: Codable {
    var data: [Coin]
    var timestamp: Int
}

struct CoinQuery: Codable {
    var data: Coin
}

struct Coin: Hashable, Codable, Identifiable {
    var id: String
    var rank: String
    var symbol: String
    var name: String
    var supply: Double
    var maxSupply: Double?
    var marketCap: Double
    var volume: Double
    var price: Double
    var changePercent: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case rank
        case symbol
        case name
        case supply
        case maxSupply
        case marketCap = "marketCapUsd"
        case volume = "volumeUsd24Hr"
        case price = "priceUsd"
        case changePercent = "changePercent24Hr"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        rank = try values.decode(String.self, forKey: .rank)
        symbol = try values.decode(String.self, forKey: .symbol)
        name = try values.decode(String.self, forKey: .name)

        supply = Double(try values.decode(String.self, forKey: .supply)) ?? 0.0
        marketCap = Double(try values.decode(String.self, forKey: .marketCap)) ?? 0.0
        volume = Double(try values.decode(String.self, forKey: .volume)) ?? 0.0
        price = Double(try values.decode(String.self, forKey: .price)) ?? 0.0

        if let changePercentStr = try values.decodeIfPresent(String.self, forKey: .changePercent) {
            changePercent = Double(changePercentStr) ?? 0.0
        } else {
            changePercent = 0.0
        }

        maxSupply = if let maxSupplyStr = try values.decodeIfPresent(String.self, forKey: .maxSupply) {
            Double(maxSupplyStr)
        } else {
            nil
        }
    }
}
