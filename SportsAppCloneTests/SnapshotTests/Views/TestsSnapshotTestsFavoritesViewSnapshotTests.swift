//
//  FavoritesViewSnapshotTests.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import SportsAppClone

/// Snapshot tests for FavoritesView
/// Tests empty states, populated lists, and various configurations
@Suite("FavoritesView Snapshot Tests")
@MainActor
struct FavoritesViewSnapshotTests {
    
    // MARK: - Mock Data Service
    
    /// Creates a mock view model with test data
    private func createMockViewModel(favoriteTeams: [Team] = []) -> SportsViewModel {
        // For snapshot testing, we need a way to inject test data
        // In production, you'd create a protocol-based service for dependency injection
        let viewModel = SportsViewModel()
        
        // Simulate loaded data by setting favorites directly
        for team in favoriteTeams {
            viewModel.toggleFavorite(for: team)
        }
        
        return viewModel
    }
    
    // MARK: - Empty State Tests
    
    @Test("Favorites view - Empty state")
    func favoritesViewEmptyState() async throws {
        let viewModel = createMockViewModel(favoriteTeams: [])
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        // Light mode
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-state-light"
        )
        
        // Dark mode
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-state-dark"
        )
    }
    
    // MARK: - Single Team Tests
    
    @Test("Favorites view - Single team")
    func favoritesViewSingleTeam() async throws {
        let team = Team(
            name: "49ers",
            abbreviation: "SF",
            location: "San Francisco",
            primaryColor: "#AA0000",
            leagueID: UUID(),
            isFavorite: true
        )
        
        let viewModel = createMockViewModel(favoriteTeams: [team])
        
        // Manually create leagues to satisfy the view's requirements
        let leagues = SnapshotTestingHelpers.createMockLeagues()
        // Note: In production, you'd ensure the viewModel has leagues loaded
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "single-team-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "single-team-dark"
        )
    }
    
    // MARK: - Multiple Teams Tests
    
    @Test("Favorites view - Multiple teams")
    func favoritesViewMultipleTeams() async throws {
        let teams = [
            Team(
                name: "49ers",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#AA0000",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Warriors",
                abbreviation: "GSW",
                location: "Golden State",
                primaryColor: "#1D428A",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Giants",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#FD5A1E",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Sharks",
                abbreviation: "SJ",
                location: "San Jose",
                primaryColor: "#006D75",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "multiple-teams-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "multiple-teams-dark"
        )
    }
    
    // MARK: - Many Teams Tests
    
    @Test("Favorites view - Many teams (scrolling)")
    func favoritesViewManyTeams() async throws {
        let teams = [
            Team(name: "49ers", abbreviation: "SF", location: "San Francisco", primaryColor: "#AA0000", leagueID: UUID(), isFavorite: true),
            Team(name: "Chiefs", abbreviation: "KC", location: "Kansas City", primaryColor: "#E31837", leagueID: UUID(), isFavorite: true),
            Team(name: "Cowboys", abbreviation: "DAL", location: "Dallas", primaryColor: "#003594", leagueID: UUID(), isFavorite: true),
            Team(name: "Warriors", abbreviation: "GSW", location: "Golden State", primaryColor: "#1D428A", leagueID: UUID(), isFavorite: true),
            Team(name: "Lakers", abbreviation: "LAL", location: "Los Angeles", primaryColor: "#552583", leagueID: UUID(), isFavorite: true),
            Team(name: "Celtics", abbreviation: "BOS", location: "Boston", primaryColor: "#007A33", leagueID: UUID(), isFavorite: true),
            Team(name: "Yankees", abbreviation: "NYY", location: "New York", primaryColor: "#003087", leagueID: UUID(), isFavorite: true),
            Team(name: "Red Sox", abbreviation: "BOS", location: "Boston", primaryColor: "#BD3039", leagueID: UUID(), isFavorite: true)
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 800)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "many-teams-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "many-teams-dark"
        )
    }
    
    // MARK: - Accessibility Tests
    
    @Test("Favorites view - Extra large text")
    func favoritesViewAccessibilityExtraLarge() async throws {
        let teams = [
            Team(
                name: "Warriors",
                abbreviation: "GSW",
                location: "Golden State",
                primaryColor: "#1D428A",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Lakers",
                abbreviation: "LAL",
                location: "Los Angeles",
                primaryColor: "#552583",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
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
    
    @Test("Favorites view - Extra extra large text")
    func favoritesViewAccessibilityExtraExtraLarge() async throws {
        let teams = [
            Team(
                name: "Celtics",
                abbreviation: "BOS",
                location: "Boston",
                primaryColor: "#007A33",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xxl-light"
        )
    }
    
    @Test("Favorites view - Empty state accessibility")
    func favoritesViewEmptyStateAccessibility() async throws {
        let viewModel = createMockViewModel(favoriteTeams: [])
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        .environment(\.sizeCategory, .accessibilityExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-state-accessibility-light"
        )
    }
    
    // MARK: - Device Size Variations
    
    @Test("Favorites view - iPhone SE")
    func favoritesViewiPhoneSE() async throws {
        let teams = [
            Team(
                name: "49ers",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#AA0000",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Warriors",
                abbreviation: "GSW",
                location: "Golden State",
                primaryColor: "#1D428A",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 375, height: 667)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-se-light"
        )
    }
    
    @Test("Favorites view - iPhone Pro Max")
    func favoritesViewiPhoneProMax() async throws {
        let teams = [
            Team(
                name: "Chiefs",
                abbreviation: "KC",
                location: "Kansas City",
                primaryColor: "#E31837",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Cowboys",
                abbreviation: "DAL",
                location: "Dallas",
                primaryColor: "#003594",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 430, height: 932)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-pro-max-light"
        )
    }
    
    @Test("Favorites view - iPad")
    func favoritesViewiPad() async throws {
        let teams = [
            Team(name: "Yankees", abbreviation: "NYY", location: "New York", primaryColor: "#003087", leagueID: UUID(), isFavorite: true),
            Team(name: "Red Sox", abbreviation: "BOS", location: "Boston", primaryColor: "#BD3039", leagueID: UUID(), isFavorite: true),
            Team(name: "Dodgers", abbreviation: "LAD", location: "Los Angeles", primaryColor: "#005A9C", leagueID: UUID(), isFavorite: true)
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 768, height: 1024)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "ipad-light"
        )
    }
    
    // MARK: - Edge Cases
    
    @Test("Favorites view - Teams with long names")
    func favoritesViewLongNames() async throws {
        let teams = [
            Team(
                name: "Super Long Team Name United FC",
                abbreviation: "SLTNU",
                location: "San Francisco Bay Area",
                primaryColor: "#FF6600",
                leagueID: UUID(),
                isFavorite: true
            ),
            Team(
                name: "Another Extremely Long Name",
                abbreviation: "AELN",
                location: "Greater Los Angeles Region",
                primaryColor: "#0066FF",
                leagueID: UUID(),
                isFavorite: true
            )
        ]
        
        let viewModel = createMockViewModel(favoriteTeams: teams)
        
        let view = NavigationStack {
            FavoritesView(viewModel: viewModel)
        }
        .frame(width: 390, height: 600)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "long-names-light"
        )
    }
}
