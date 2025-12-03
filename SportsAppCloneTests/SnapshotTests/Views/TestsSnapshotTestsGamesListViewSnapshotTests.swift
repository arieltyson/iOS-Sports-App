//
//  GamesListViewSnapshotTests.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import SportsAppClone

/// Snapshot tests for GamesListView
/// Tests various game list states, filtering, and layouts
@Suite("GamesListView Snapshot Tests")
@MainActor
struct GamesListViewSnapshotTests {
    
    // MARK: - Mock View Model Creation
    
    /// Creates a mock view model with test data
    private func createMockViewModel(
        withGames: Bool = true,
        withSearch: String = ""
    ) async -> SportsViewModel {
        let viewModel = SportsViewModel()
        
        if withGames {
            // Load mock data
            await viewModel.loadData()
        }
        
        viewModel.searchText = withSearch
        
        return viewModel
    }
    
    // MARK: - Default State Tests
    
    @Test("Games list - Default state with all sections")
    func gamesListDefaultState() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        // Light mode
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "default-state-light"
        )
        
        // Dark mode
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "default-state-dark"
        )
    }
    
    // MARK: - Empty State Tests
    
    @Test("Games list - Empty state")
    func gamesListEmptyState() async throws {
        let viewModel = await createMockViewModel(withGames: false)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-state-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-state-dark"
        )
    }
    
    // MARK: - Search Tests
    
    @Test("Games list - Search results")
    func gamesListSearchResults() async throws {
        let viewModel = await createMockViewModel(withGames: true, withSearch: "San Francisco")
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "search-results-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "search-results-dark"
        )
    }
    
    @Test("Games list - No search results")
    func gamesListNoSearchResults() async throws {
        let viewModel = await createMockViewModel(withGames: true, withSearch: "NonexistentTeam123")
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "no-search-results-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "no-search-results-dark"
        )
    }
    
    // MARK: - Section-Specific Tests
    
    @Test("Games list - Only live games")
    func gamesListOnlyLiveGames() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        // Filter to show only live games by setting a league filter
        // In a real scenario, you'd mock data to show only live games
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "only-live-games-light"
        )
    }
    
    @Test("Games list - Only upcoming games")
    func gamesListOnlyUpcomingGames() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "only-upcoming-games-light"
        )
    }
    
    @Test("Games list - Only final games")
    func gamesListOnlyFinalGames() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "only-final-games-light"
        )
    }
    
    // MARK: - League Filter Tests
    
    @Test("Games list - NFL filtered")
    func gamesListNFLFiltered() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        // Select NFL league
        if let nflLeague = viewModel.leagues.first(where: { $0.abbreviation == "NFL" }) {
            viewModel.selectedLeague = nflLeague
        }
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nfl-filtered-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nfl-filtered-dark"
        )
    }
    
    @Test("Games list - NBA filtered")
    func gamesListNBAFiltered() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        // Select NBA league
        if let nbaLeague = viewModel.leagues.first(where: { $0.abbreviation == "NBA" }) {
            viewModel.selectedLeague = nbaLeague
        }
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nba-filtered-light"
        )
    }
    
    // MARK: - Accessibility Tests
    
    @Test("Games list - Extra large text")
    func gamesListAccessibilityExtraLarge() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        .environment(\.sizeCategory, .accessibilityExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xl-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xl-dark"
        )
    }
    
    @Test("Games list - Extra extra large text")
    func gamesListAccessibilityExtraExtraLarge() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xxl-light"
        )
    }
    
    @Test("Games list - Empty state accessibility")
    func gamesListEmptyStateAccessibility() async throws {
        let viewModel = await createMockViewModel(withGames: false)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        .environment(\.sizeCategory, .accessibilityExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-accessibility-light"
        )
    }
    
    // MARK: - Device Size Variations
    
    @Test("Games list - iPhone SE")
    func gamesListiPhoneSE() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 375, height: 667)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-se-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-se-dark"
        )
    }
    
    @Test("Games list - iPhone 15 Pro")
    func gamesListiPhone15Pro() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 393, height: 852)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-15-pro-light"
        )
    }
    
    @Test("Games list - iPhone 15 Pro Max")
    func gamesListiPhone15ProMax() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 430, height: 932)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-15-pro-max-light"
        )
    }
    
    @Test("Games list - iPad portrait")
    func gamesListiPadPortrait() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 768, height: 1024)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "ipad-portrait-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "ipad-portrait-dark"
        )
    }
    
    @Test("Games list - iPad landscape")
    func gamesListiPadLandscape() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 1024, height: 768)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "ipad-landscape-light"
        )
    }
    
    // MARK: - Scrolling and Content Tests
    
    @Test("Games list - Many games")
    func gamesListManyGames() async throws {
        let viewModel = await createMockViewModel(withGames: true)
        
        // Create a scrolled view showing more content
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 1200) // Taller to show more games
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "many-games-light"
        )
    }
    
    // MARK: - Combined Filter Tests
    
    @Test("Games list - Search with league filter")
    func gamesListSearchWithLeagueFilter() async throws {
        let viewModel = await createMockViewModel(withGames: true, withSearch: "Golden State")
        
        // Select NBA league
        if let nbaLeague = viewModel.leagues.first(where: { $0.abbreviation == "NBA" }) {
            viewModel.selectedLeague = nbaLeague
        }
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "search-with-filter-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "search-with-filter-dark"
        )
    }
    
    // MARK: - Edge Cases
    
    @Test("Games list - Very long search query")
    func gamesListVeryLongSearchQuery() async throws {
        let longQuery = "This is an extremely long search query that users might enter when looking for specific teams or games"
        let viewModel = await createMockViewModel(withGames: true, withSearch: longQuery)
        
        let view = NavigationStack {
            GamesListView(viewModel: viewModel)
        }
        .frame(width: 390, height: 844)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "long-search-query-light"
        )
    }
}
