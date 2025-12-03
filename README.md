# SportsAppClone

A modern SwiftUI sports app demonstrating MVVM architecture and iOS best practices.

![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-lightgrey.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)

## 📚 Documentation

### Core Documentation
- **[README](docs/README.md)** - Comprehensive project overview and technical details
- **[Architecture Diagram](docs/ARCHITECTURE_DIAGRAM.md)** - Visual architecture guide and data flow
- **[Complete Overview](docs/COMPLETE_OVERVIEW.md)** - Detailed feature list and implementation guide
- **[Project Summary](docs/PROJECT_SUMMARY.md)** - Executive summary and key highlights

### Implementation Guides
- **[AI Integration Guide](docs/AI_INTEGRATION_GUIDE.md)** - AI/ML integration strategies and examples
- **[Snapshot Testing Guide](docs/SNAPSHOT_TESTING_GUIDE.md)** - Testing strategy and best practices

### Interview Preparation
- **[Interview Prep](docs/INTERVIEW_PREP.md)** - Talking points and demo walkthrough
- **[Pre-Interview Checklist](docs/PRE_INTERVIEW_CHECKLIST.md)** - Final preparation checklist

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repository-url>

# Open in Xcode
open SportsAppClone.xcodeproj

# Build and run
⌘R
```

**Requirements:**
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift 6.0+

## 🏗️ Architecture

This app follows **MVVM (Model-View-ViewModel)** architecture with modern Swift features:

```
SportsAppClone/
│
├── App/              # Application entry point
│   └── SportsAppCloneApp.swift
│
├── Models/           # 📊 Domain models (MVVM: Model)
│   └── Sport.swift   # Team, Game, League, GameStatus
│
├── ViewModels/       # 🎛️ Business logic (MVVM: ViewModel)
│   └── SportsViewModel.swift
│
├── Views/            # 🎨 UI layer (MVVM: View)
│   ├── ContentView.swift
│   ├── GamesListView.swift
│   ├── FavoritesView.swift
│   ├── GameDetailView.swift
│   └── Components/   # Reusable UI components
│       ├── GameCardView.swift
│       └── LeagueFilterView.swift
│
├── Services/         # 🔌 Data & API layer
│   └── SportsDataService.swift
│
└── Resources/        # Assets & configuration
    └── Assets.xcassets
```

See **[Architecture Diagram](docs/ARCHITECTURE_DIAGRAM.md)** for detailed information.

## ✨ Key Features

### Modern Swift & SwiftUI
- ✅ **Swift 6.0+** with latest language features
- ✅ **`@Observable` macro** for state management (iOS 17+)
- ✅ **Swift Concurrency** (async/await, actors)
- ✅ **Type-safe navigation** with NavigationStack
- ✅ **Observation framework** (no Combine needed)

### User Interface
- ✅ Tab-based navigation (Games / Favorites)
- ✅ Live game status indicators
- ✅ League filtering with horizontal scrolling
- ✅ Search functionality
- ✅ Pull-to-refresh
- ✅ Detailed game views
- ✅ Favorites management
- ✅ Dark mode support

### Architecture Benefits
- ✅ **Testable** - Comprehensive test coverage
- ✅ **Maintainable** - Clear separation of concerns
- ✅ **Scalable** - Easy to add new features
- ✅ **Swifty** - Idiomatic Swift code
- ✅ **Production-ready** - Follows best practices

## 🧪 Testing

Run tests with `⌘U` or through Xcode's Test Navigator.

```
Tests/
├── ViewModelTests/
│   └── SportsViewModelTests.swift   # ViewModel unit tests
└── SportsAppCloneTests.swift        # Integration tests
```

**Test Coverage Includes:**
- Data loading and state management
- Filtering and search functionality
- Game status identification
- Favorites management
- Data consistency validation
- Model behavior verification

See **[Snapshot Testing Guide](docs/SNAPSHOT_TESTING_GUIDE.md)** for testing strategy.

## 📱 App Structure

### MVVM Layers

| Layer | Responsibility | Example |
|-------|---------------|---------|
| **Model** | Pure data structures | `Team`, `Game`, `League` |
| **ViewModel** | Business logic & state | `SportsViewModel` |
| **View** | SwiftUI UI components | `GamesListView`, `GameCardView` |
| **Service** | Data fetching & persistence | `SportsDataService` |

### Data Flow

```
User Action → View → ViewModel → Service → Model
                ↓         ↑
            Binding   Observable
```

## 🎯 Technical Highlights

### Observation Framework
```swift
@Observable
@MainActor
final class SportsViewModel {
    private(set) var games: [Game] = []
    var selectedLeague: League?  // Automatically observable
    
    func loadData() async { ... }
}
```

### Swift Concurrency
```swift
async let gamesTask = dataService.fetchGames()
async let leaguesTask = dataService.fetchLeagues()
let (games, leagues) = try await (gamesTask, leaguesTask)
```

### Modern Swift Testing
```swift
@Test("Filter games by league")
func filterGamesByLeague() async throws {
    let viewModel = SportsViewModel()
    await viewModel.loadData()
    #expect(!viewModel.games.isEmpty)
}
```

## 🛠️ Development

### Adding New Features

1. **Model** - Define data structures in `Models/`
2. **Service** - Add data fetching in `Services/`
3. **ViewModel** - Implement business logic in `ViewModels/`
4. **View** - Create UI in `Views/` or `Views/Components/`
5. **Tests** - Add tests in `Tests/`

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful names
- Keep functions small and focused
- Add comments for complex logic
- Use `// MARK:` for organization

### Best Practices
- ✅ Use `@Observable` for view models
- ✅ Keep views declarative and simple
- ✅ Use `async/await` for async operations
- ✅ Mark view models with `@MainActor`
- ✅ Make computed properties for derived state
- ✅ Write tests for business logic

## 📦 Dependencies

This project uses **zero external dependencies** - pure Swift and Apple frameworks:
- SwiftUI
- Foundation
- Swift Testing
- Observation

## 🗺️ Roadmap

Future enhancements (see [AI Integration Guide](docs/AI_INTEGRATION_GUIDE.md)):

- [ ] Real API integration
- [ ] WebSocket for live updates
- [ ] Core ML predictions
- [ ] Widget extension
- [ ] Watch app
- [ ] Snapshot testing implementation
- [ ] Offline support
- [ ] Push notifications

## 📖 Learning Resources

### Documentation
- [MVVM Pattern](docs/ARCHITECTURE_DIAGRAM.md)
- [Swift Observation](https://developer.apple.com/documentation/observation)
- [SwiftUI Best Practices](docs/README.md)
- [Testing Strategy](docs/SNAPSHOT_TESTING_GUIDE.md)

### Apple Documentation
- [SwiftUI Framework](https://developer.apple.com/documentation/swiftui)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
- [Swift Testing](https://developer.apple.com/documentation/testing)

## 🤝 Contributing

This project was built as a technical showcase. For interview context, see:
- [Interview Prep](docs/INTERVIEW_PREP.md)
- [Complete Overview](docs/COMPLETE_OVERVIEW.md)

## 👨‍💻 Author

**Ariel Tyson**

Built with ❤️ using Swift and SwiftUI

---

**For detailed documentation, see the [`docs/`](docs/) folder.**

**Ready to ship. Ready to iterate. Ready to build the future of sports apps.** 🏈🏀⚽️
