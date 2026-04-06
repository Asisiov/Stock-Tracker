# Real-Time Stock Price Tracker

iOS assessment project that displays live price updates for multiple stock symbols and supports a details screen for a selected symbol.

## Objective

Build an iOS app that:

- displays real-time price updates for **25 stock symbols**
- shows a **scrollable symbols list**
- supports **sorting by price** and **sorting by price change**
- opens a **symbol details screen**
- keeps updates consistent across **list** and **details**
- shows **connection status**
- allows the user to **start** and **stop** the price feed
- integrates with a **WebSocket echo endpoint**

## Features

### Symbols List Screen
- Displays symbol ticker / name
- Displays current price
- Displays price change indicator
- Supports sorting:
  - by **Price**
  - by **Price Change**
- Opens details screen when a row is selected

### Symbol Details Screen
- Displays selected symbol title
- Displays current price
- Displays the same price change indicator used on the list
- Displays a short description about the symbol
- Displays feed connection status
- Provides **Start Feed** / **Stop Feed** control

### Real-Time Updates
- Price updates propagate across screens in real time
- Detail screen stays bound to the selected symbol even if the list order changes
- Sorting remains correct while live updates are received

## Tech Stack

- **Swift**
- **SwiftUI**
- **URLSessionWebSocketTask**
- **AsyncSequence / AsyncStream**
- **Unit Tests (XCTest / Testing, depending on target setup)**

## Architecture

This project is structured around a layered architecture to keep business logic testable and UI independent from networking details.

### Layers

#### Presentation
Responsible for:
- SwiftUI views
- View models
- UI state
- Navigation

#### Domain
Responsible for:
- core models
- sorting rules
- price change calculation
- connection state rules
- use-case level abstractions

#### Data
Responsible for:
- repository implementation
- WebSocket client
- mock feed / fixtures
- mapping transport payloads into domain models

## Main Design Decisions

### 1. Repository as a Single Source of Truth
The repository owns the current list of symbols and connection state.

This gives:
- one consistent data flow
- synchronized updates between list and details
- simpler testability

### 2. Shared Live State Across Screens
List and details do not maintain separate live data sources.  
Both screens consume the same underlying symbol state, so price updates stay consistent.

### 3. Mock Feed First, Then Real WebSocket
The project is designed so UI can be built and tested against a mock feed first, then switched to the real echo-based WebSocket integration without rewriting the presentation layer.

### 4. Protocol-Driven Boundaries
Key services are abstracted behind protocols so that:
- mocks can be injected in tests
- WebSocket implementation can be replaced
- view models remain isolated from infrastructure

### 5. Sorting Under Live Updates
Sorting is recalculated whenever symbol prices change.  
Selection is preserved by symbol ID, not by row position.

## WebSocket Integration

The app connects to:

`wss://ws.postman-echo.com/raw`

Flow:
1. App generates a random price update payload
2. Payload is sent through WebSocket
3. Echo endpoint sends the same payload back
4. Payload is decoded and mapped
5. Repository updates the corresponding symbol
6. UI refreshes automatically

## Project Structure

Example structure:

```text
StockPriceTracker/
├── App/
├── Presentation/
│   ├── SymbolsList/
│   ├── SymbolDetails/
│   ├── Shared/
├── Domain/
│   ├── Models/
│   ├── UseCases/
│   ├── Contracts/
├── Data/
│   ├── Repository/
│   ├── WebSocket/
│   ├── Mappers/
│   ├── Mock/
├── Resources/
│   ├── Localizable.strings
│   ├── Assets.xcassets
├── Tests/
│   ├── DomainTests/
│   ├── PresentationTests/
│   ├── DataTests/
```

## Run Instructions

### Requirements
- Xcode 16+
- iOS 17+
- macOS with network access for WebSocket connection

### Run
1. Clone the repository
2. Open the Xcode project or workspace
3. Select the iOS app target
4. Run on Simulator or physical device
5. Open the symbols list
6. Tap **Start Feed**
7. Observe live price updates
8. Open a symbol details screen and verify that updates continue there as well

## Testing Strategy

This project focuses on **unit testing** with clear CI-ready targets.

### Covered Areas

#### Domain Tests
- price change calculation
- indicator direction mapping
- sorting by price
- sorting by price change
- connection state transitions

#### ViewModel Tests
- symbols list loading
- sorting changes
- start / stop feed actions
- details screen state mapping
- live updates propagation into presentation state

#### Repository / Service Tests
- symbol update propagation
- connection state propagation
- WebSocket payload mapping
- malformed payload handling
- consistency between list and details consumers

## Assumptions

- Prices are generated locally and echoed back through the WebSocket endpoint
- The echo endpoint is used only to simulate transport, not as a real market data provider
- Symbol descriptions are static mock content
- Reconnection strategy is kept minimal unless explicitly extended
- UI tests are intentionally out of scope for this assessment version

## Scope Boundaries

Included:
- 25 mock symbols
- list screen
- details screen
- live updates
- sort by price
- sort by price change
- connection status
- start / stop feed
- WebSocket echo integration
- unit tests

Not included:
- real stock market API
- persistence
- authentication
- portfolio / watchlist management
- alerts / notifications
- UI automation tests

## Localization & Formatting

The project is prepared for:
- localized user-facing strings
- locale-aware price formatting
- reusable formatting abstractions

## Code Style

The project follows a strict section marker rule:

```swift
// MARK:  -  Section Name  -  
```

This format is required and intentionally preserved across the codebase.

## Future Improvements

- reconnect / retry policy with backoff
- snapshot and integration tests
- offline state handling
- persistence of last known prices
- modularization into separate packages / targets
- accessibility audit and VoiceOver polish

## Deliverable

This repository is intended to be submitted as a **public GitHub repository** containing:
- source code
- tests
- README
- clear structure and source control history

---

## Summary

This project demonstrates:
- real-time UI updates in SwiftUI
- shared state across multiple screens
- protocol-oriented architecture
- WebSocket-based update pipeline
- unit-testable design ready for CI
