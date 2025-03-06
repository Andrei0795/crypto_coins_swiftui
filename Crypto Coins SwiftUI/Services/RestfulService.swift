//
//  RestfulService.swift
//  Crypto Coins SwiftUI
//
//  Created by Andrei Ionescu on 06.03.2025.
//

import Foundation

class RestfulService {
    private let coinStoreUrl = "https://api.coincap.io/v2/assets/"
    
    func getAllCoins(limit: Int = 0) async -> [Coin]? {
        
        var queryUrl = coinStoreUrl
        
        if limit > 0 {
            queryUrl += "?limit=\(limit)"
        }
        
        guard let url = URL(string: queryUrl) else {
            return nil
        }
        
        var coin: [Coin]? = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let jsonString = String(data: data, encoding: .utf8)
            print("Received JSON: \(jsonString ?? "Invalid JSON")")
            
            let coinContainer = try JSONDecoder().decode(CoinStore.self, from: data)
            coin = coinContainer.data
            
            
        } catch {
            print(error)
        }
        
        return coin
    }
    
    func getCoin(_ coinId: String) async -> Coin? {
        
        guard let url = URL(string: coinStoreUrl + coinId) else {
            return nil
        }
        
        var coin: Coin? = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let coinContainer = try JSONDecoder().decode(CoinQuery.self, from: data)
            coin = coinContainer.data
            
        } catch {
            print(error)
        }
        
        return coin
    }
}
