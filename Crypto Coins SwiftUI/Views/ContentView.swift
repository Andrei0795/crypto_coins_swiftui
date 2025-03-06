//
//  ContentView.swift
//  Crypto Coins SwiftUI
//
//  Created by Andrei Ionescu on 06.03.2025.
//

import SwiftUI

struct ContentView: View {
    private var coinWebSocket = WebSocketService()
    private var coinService = RestfulService()
    
    @State private var priceChange: [Bool] = []
    @State private var coins: [Coin] = []
    
    private var gridItemLayout: [GridItem] = [
        GridItem(.flexible()) // Only one item per row
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Rank")
                    Text("Name")
                    Spacer()
                    Text("Price")
                    Text("Change in %")
                }
                .padding(.horizontal, 5)
                .fontWeight(.heavy)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.5))
                
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 15) {
                            ForEach(Array(coins.enumerated()), id: \.element.id) { index, coin in
                                CoinCellView(coin: coin, isPriceChanging: priceChange[index])
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
            .navigationTitle("Crypto Coin Tracker")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                coins = await coinService.getAllCoins() ?? []
                priceChange = .init(repeating: false, count: coins.count)
                let allCoinIDs = coins.map { $0.id.lowercased() } // Extract all coin IDs
                await coinWebSocket.connect(with: allCoinIDs)
            }
        }
        .refreshable {
            coins = await coinService.getAllCoins() ?? []
        }
        .onChange(of: coinWebSocket.coins) { oldValue, newValue in
            newValue.forEach { key, value in
                updateCoinPrice(coin: [key: value])
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func updateCoinPrice(coin: [String: Double]) {
        guard let key = coin.keys.first,
              let value = coin[key] else {
            return
        }
        
        guard let index = coins.firstIndex(where: { $0.name.lowercased() == key.lowercased() }) else { return }
        coins[index].price = value
        
        withAnimation(.easeInOut.repeatCount(2, autoreverses: true)) {
            priceChange[index].toggle()
        }
    }
}

struct CoinCellView: View {
    let coin: Coin
    let isPriceChanging: Bool
    
    @State private var showHighlight: Bool = false
    
    var body: some View {
        HStack {
            Text(coin.rank)
            VStack(alignment: .leading) {
                Text(coin.name).fontWeight(.medium)
                Text(coin.symbol).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(coin.price.formatted(.number.precision(.fractionLength(coin.price < 1.0 ? 6 : 2))))")
                .fontWeight(.medium)
                .background(showHighlight ? Color.yellow.opacity(0.5) : Color.clear)
            Text(((coin.changePercent ?? 100.0) / 100).formatted(.percent.precision(.fractionLength(2))))
                .foregroundStyle((coin.changePercent ?? 0.0) > 0.0 ? Color.green : Color.red)
        }
        .padding(.horizontal, 5)
        .onChange(of: isPriceChanging) {
            showHighlight = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showHighlight = false
            }
        }
    }
}

#Preview {
    ContentView()
}
