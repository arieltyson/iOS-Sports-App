//
//  GameCardViewSnapshotTests.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import SportsAppClone

/// Snapshot tests for GameCardView component
/// Tests various game states, color schemes, and device configurations
@Suite("GameCardView Snapshot Tests")
@MainActor
struct GameCardViewSnapshotTests {
    
    // MARK: - Test Configuration
    
    private let defaultDevices: [SnapshotTestingHelpers.DeviceConfig] = [
        .iPhone15Pro,
        .iPhoneSE
    ]
    
    // MARK: - Live Game States
    
    @Test("Live game - Home team winning")
    func liveGameHomeWinning() async throws {
        let game = Game(
            homeTeam: createTeam(name: "49ers", abbreviation: "SF", location: "San Francisco", color: "#AA0000"),
            awayTeam: createTeam(name: "Chiefs", abbreviation: "KC", location: "Kansas City", color: "#E31837"),
            homeScore: 28,
            awayScore: 21,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        // Test light mode
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-home-winning-light"
        )
        
        // Test dark mode
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-home-winning-dark"
        )
    }
    
    @Test("Live game - Away team winning")
    func liveGameAwayWinning() async throws {
        let game = Game(
            homeTeam: createTeam(name: "Warriors", abbreviation: "GSW", location: "Golden State", color: "#1D428A"),
            awayTeam: createTeam(name: "Lakers", abbreviation: "LAL", location: "Los Angeles", color: "#552583"),
            homeScore: 98,
            awayScore: 105,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-away-winning-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-away-winning-dark"
        )
    }
    
    @Test("Live game - Tied score")
    func liveGameTied() async throws {
        let game = Game(
            homeTeam: createTeam(name: "Cowboys", abbreviation: "DAL", location: "Dallas", color: "#003594"),
            awayTeam: createTeam(name: "Giants", abbreviation: "NYG", location: "New York", color: "#0B2265"),
            homeScore: 17,
            awayScore: 17,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-tied-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "live-tied-dark"
        )
    }
    
    // MARK: - Scheduled Game States
    
    @Test("Scheduled game - Future date")
    func scheduledGame() async throws {
        let futureDate = Date().addingTimeInterval(7200) // 2 hours from now
        
        let game = Game(
            homeTeam: createTeam(name: "Celtics", abbreviation: "BOS", location: "Boston", color: "#007A33"),
            awayTeam: createTeam(name: "Heat", abbreviation: "MIA", location: "Miami", color: "#98002E"),
            status: .scheduled,
            scheduledTime: futureDate,
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "scheduled-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "scheduled-dark"
        )
    }
    
    // MARK: - Final Game States
    
    @Test("Final game - Close score")
    func finalGameCloseScore() async throws {
        let pastDate = Date().addingTimeInterval(-3600) // 1 hour ago
        
        let game = Game(
            homeTeam: createTeam(name: "Yankees", abbreviation: "NYY", location: "New York", color: "#003087"),
            awayTeam: createTeam(name: "Red Sox", abbreviation: "BOS", location: "Boston", color: "#BD3039"),
            homeScore: 4,
            awayScore: 3,
            status: .final,
            scheduledTime: pastDate,
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "final-close-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "final-close-dark"
        )
    }
    
    @Test("Final game - Blowout")
    func finalGameBlowout() async throws {
        let pastDate = Date().addingTimeInterval(-7200) // 2 hours ago
        
        let game = Game(
            homeTeam: createTeam(name: "Seahawks", abbreviation: "SEA", location: "Seattle", color: "#002244"),
            awayTeam: createTeam(name: "Cardinals", abbreviation: "ARI", location: "Arizona", color: "#97233F"),
            homeScore: 42,
            awayScore: 10,
            status: .final,
            scheduledTime: pastDate,
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "final-blowout-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "final-blowout-dark"
        )
    }
    
    // MARK: - Postponed Game State
    
    @Test("Postponed game")
    func postponedGame() async throws {
        let futureDate = Date().addingTimeInterval(10800) // 3 hours from now
        
        let game = Game(
            homeTeam: createTeam(name: "Maple Leafs", abbreviation: "TOR", location: "Toronto", color: "#00205B"),
            awayTeam: createTeam(name: "Canadiens", abbreviation: "MTL", location: "Montreal", color: "#AF1E2D"),
            status: .postponed,
            scheduledTime: futureDate,
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "postponed-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "postponed-dark"
        )
    }
    
    // MARK: - Accessibility Tests
    
    @Test("Game card - Extra large text")
    func gameCardAccessibilityExtraLarge() async throws {
        let game = Game(
            homeTeam: createTeam(name: "Rockets", abbreviation: "HOU", location: "Houston", color: "#CE1141"),
            awayTeam: createTeam(name: "Mavericks", abbreviation: "DAL", location: "Dallas", color: "#00538C"),
            homeScore: 110,
            awayScore: 108,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
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
    
    @Test("Game card - Extra extra large text")
    func gameCardAccessibilityExtraExtraLarge() async throws {
        let game = Game(
            homeTeam: createTeam(name: "Nuggets", abbreviation: "DEN", location: "Denver", color: "#0E2240"),
            awayTeam: createTeam(name: "Suns", abbreviation: "PHX", location: "Phoenix", color: "#1D1160"),
            homeScore: 95,
            awayScore: 92,
            status: .final,
            scheduledTime: Date().addingTimeInterval(-3600),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xxl-light"
        )
    }
    
    // MARK: - Edge Cases
    
    @Test("Game card - Long team names")
    func gameCardLongTeamNames() async throws {
        let game = Game(
            homeTeam: Team(
                name: "Super Long Team Name United",
                abbreviation: "SLTNU",
                location: "San Francisco Bay Area",
                primaryColor: "#FF6600",
                leagueID: UUID()
            ),
            awayTeam: Team(
                name: "Another Very Long Name FC",
                abbreviation: "AVLNFC",
                location: "Greater Los Angeles",
                primaryColor: "#0066FF",
                leagueID: UUID()
            ),
            homeScore: 3,
            awayScore: 2,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "long-names-light"
        )
    }
    
    @Test("Game card - High scores")
    func gameCardHighScores() async throws {
        let game = Game(
            homeTeam: createTeam(name: "Team A", abbreviation: "A", location: "City A", color: "#FF0000"),
            awayTeam: createTeam(name: "Team B", abbreviation: "B", location: "City B", color: "#0000FF"),
            homeScore: 143,
            awayScore: 138,
            status: .final,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        let view = GameCardView(game: game)
            .frame(width: 380)
            .padding()
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "high-scores-light"
        )
    }
    
    // MARK: - Helper Methods
    
    private func createTeam(
        name: String,
        abbreviation: String,
        location: String,
        color: String
    ) -> Team {
        Team(
            name: name,
            abbreviation: abbreviation,
            location: location,
            primaryColor: color,
            leagueID: UUID()
        )
    }
}
