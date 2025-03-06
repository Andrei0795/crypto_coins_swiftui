# crypto_coins_swiftui

CryptoTracker is a real-time cryptocurrency tracking app that provides instant price updates for Bitcoin, Ethereum, Dogecoin, and other major digital assets. It utilizes WebSockets to deliver live price changes without delays, ensuring you stay up to date with market fluctuations.

## Features

- **Live Price Updates** – Get real-time cryptocurrency prices using WebSocket technology.
- **Smart UI Highlights** – Price changes are visually highlighted for easy tracking.
- **Historical Price Changes** – View percentage changes over time.
- **Efficient & Optimized UI** – Uses a debounce mechanism to prevent excessive updates.
- **Support for Multiple Cryptos** – Dynamically subscribes to Bitcoin, Ethereum, Dogecoin, and more.
- **Battery-Friendly & Fast** – Uses WebSockets instead of polling for optimized performance.
- **Push Notifications (Coming Soon)** – Get alerts when a coin reaches a target price.

## How It Works

1. Establishes a **real-time WebSocket connection** to a crypto API.
2. Receives **instant price updates** without requiring manual refresh.
3. Highlights price changes in yellow for **0.5 seconds** before fading out.
4. Throttles updates to **every 2 seconds** to improve efficiency.

## Built With

- **Swift & SwiftUI** – For a modern and responsive user interface.
- **WebSockets** – For real-time, low-latency price updates.
- **Apple Push Notifications (Coming Soon)** – To alert users of significant price movements.

## Why Use CryptoTracker?

- Stay informed with **real-time price updates**.
- Never miss important price movements with **instant alerts**.
- Lightweight and optimized for **efficient performance**.
- Designed for traders and investors who need **accurate market insights**.

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/CryptoTracker.git
