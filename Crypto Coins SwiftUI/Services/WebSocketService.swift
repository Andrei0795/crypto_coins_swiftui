//
//  WebSocketService.swift
//  Crypto Coins SwiftUI
//
//  Created by Andrei Ionescu on 06.03.2025.
//

import Foundation

@Observable
class WebSocketService {
    private let baseURL = "wss://ws.coincap.io/prices"
    private var webSocketTask: URLSessionWebSocketTask?
    private var lastUpdateTime: Date = Date()

    var coins: [String: Double] = [:]
    
    func connect(with assets: [String]) async {
        guard !assets.isEmpty else {
            print("No assets to subscribe to.")
            return
        }
        
        let assetList = assets.joined(separator: ",")
        guard let url = URL(string: "\(baseURL)?assets=\(assetList)") else {
            print("Invalid WebSocket URL")
            return
        }
        
        print("Connecting to WebSocket: \(url)")
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        do {
            try await receiveMessages()
        } catch {
            print("WebSocket connection failed: \(error.localizedDescription)")
            await reconnect()
        }
    }
    
    func disconnect() {
        print("Disconnecting WebSocket")
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    private func reconnect() async {
        print("Reconnecting WebSocket...")
        disconnect()
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Wait 2 seconds before reconnecting
        await connect(with: Array(coins.keys)) // Reconnect with the same coins
    }
    
    private func receiveMessages() async throws {
        while webSocketTask != nil {
            do {
                let message = try await webSocketTask?.receive()
                
                switch message {
                case .string(let text):
                    print("Received: \(text)")
                    
                    if let data = text.data(using: .utf8),
                       let coinPrices = try? JSONDecoder().decode([String: String].self, from: data) {
                        
                        var updatedPrices: [String: Double] = [:]
                        coinPrices.forEach { key, value in
                            if let price = Double(value) {
                                updatedPrices[key] = price
                            }
                        }
                        
                        debounceUpdates(with: updatedPrices) // Apply debouncing

                    }
                    
                case .data(let data):
                    print("Received binary data: \(data)")
                    
                default:
                    print("Unknown WebSocket message received")
                }
            } catch {
                print("WebSocket receive error: \(error.localizedDescription)")
                await reconnect()
            }
        }
        
    }
    
    // Debounce updates to reduce UI refresh rate
        private func debounceUpdates(with newPrices: [String: Double]) {
            let now = Date()
            let timeSinceLastUpdate = now.timeIntervalSince(lastUpdateTime)

            if timeSinceLastUpdate >= 2.0 { // ✅ Only update every 2 seconds
                DispatchQueue.main.async {
                    self.coins.merge(newPrices) { _, new in new }
                    self.lastUpdateTime = Date()
                    print("🔄 UI updated with new prices")
                }
            }
        }
}
