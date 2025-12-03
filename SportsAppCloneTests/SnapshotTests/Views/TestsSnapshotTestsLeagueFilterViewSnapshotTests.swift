//
//  LeagueFilterViewSnapshotTests.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import SportsAppClone

/// Snapshot tests for LeagueFilterView component
/// Tests various selection states, color schemes, and league configurations
@Suite("LeagueFilterView Snapshot Tests")
@MainActor
struct LeagueFilterViewSnapshotTests {
    
    // MARK: - Sample Data
    
    private let sampleLeagues = [
        League(name: "National Football League", sport: .football, abbreviation: "NFL"),
        League(name: "National Basketball Association", sport: .basketball, abbreviation: "NBA"),
        League(name: "Major League Baseball", sport: .baseball, abbreviation: "MLB"),
        League(name: "National Hockey League", sport: .hockey, abbreviation: "NHL"),
        League(name: "Major League Soccer", sport: .soccer, abbreviation: "MLS")
    ]
    
    // MARK: - Default State Tests
    
    @Test("League filter - No selection (All Sports)")
    func leagueFilterNoSelection() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 60)
        
        // Light mode
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "no-selection-light"
        )
        
        // Dark mode
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "no-selection-dark"
        )
    }
    
    // MARK: - Individual League Selection Tests
    
    @Test("League filter - NFL selected")
    func leagueFilterNFLSelected() async throws {
        let nflLeague = sampleLeagues.first { $0.abbreviation == "NFL" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nflLeague)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nfl-selected-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nfl-selected-dark"
        )
    }
    
    @Test("League filter - NBA selected")
    func leagueFilterNBASelected() async throws {
        let nbaLeague = sampleLeagues.first { $0.abbreviation == "NBA" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nbaLeague)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nba-selected-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nba-selected-dark"
        )
    }
    
    @Test("League filter - MLB selected")
    func leagueFilterMLBSelected() async throws {
        let mlbLeague = sampleLeagues.first { $0.abbreviation == "MLB" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(mlbLeague)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "mlb-selected-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "mlb-selected-dark"
        )
    }
    
    @Test("League filter - NHL selected")
    func leagueFilterNHLSelected() async throws {
        let nhlLeague = sampleLeagues.first { $0.abbreviation == "NHL" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nhlLeague)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nhl-selected-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "nhl-selected-dark"
        )
    }
    
    @Test("League filter - MLS selected")
    func leagueFilterMLSSelected() async throws {
        let mlsLeague = sampleLeagues.first { $0.abbreviation == "MLS" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(mlsLeague)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "mls-selected-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "mls-selected-dark"
        )
    }
    
    // MARK: - Edge Cases
    
    @Test("League filter - Few leagues")
    func leagueFilterFewLeagues() async throws {
        let fewLeagues = Array(sampleLeagues.prefix(2))
        
        let view = LeagueFilterView(
            leagues: fewLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "few-leagues-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "few-leagues-dark"
        )
    }
    
    @Test("League filter - Empty leagues")
    func leagueFilterEmptyLeagues() async throws {
        let view = LeagueFilterView(
            leagues: [],
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-leagues-light"
        )
        
        let darkView = view.environment(\.colorScheme, .dark)
        assertSnapshot(
            of: darkView,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "empty-leagues-dark"
        )
    }
    
    @Test("League filter - Many leagues")
    func leagueFilterManyLeagues() async throws {
        // Add more leagues to test scrolling
        var manyLeagues = sampleLeagues
        manyLeagues.append(contentsOf: [
            League(name: "Women's National Basketball Association", sport: .basketball, abbreviation: "WNBA"),
            League(name: "United Soccer League", sport: .soccer, abbreviation: "USL"),
            League(name: "National Women's Soccer League", sport: .soccer, abbreviation: "NWSL")
        ])
        
        let view = LeagueFilterView(
            leagues: manyLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "many-leagues-light"
        )
    }
    
    // MARK: - Accessibility Tests
    
    @Test("League filter - Extra large text")
    func leagueFilterAccessibilityExtraLarge() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 80)
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
    
    @Test("League filter - Extra extra large text")
    func leagueFilterAccessibilityExtraExtraLarge() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 400, height: 100)
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-xxl-light"
        )
    }
    
    @Test("League filter - Accessibility with selection")
    func leagueFilterAccessibilityWithSelection() async throws {
        let nbaLeague = sampleLeagues.first { $0.abbreviation == "NBA" }
        
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nbaLeague)
        )
        .frame(width: 400, height: 80)
        .environment(\.sizeCategory, .accessibilityExtraLarge)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "accessibility-selected-light"
        )
    }
    
    // MARK: - Device Size Variations
    
    @Test("League filter - iPhone SE width")
    func leagueFilteriPhoneSEWidth() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 320, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-se-width-light"
        )
    }
    
    @Test("League filter - iPhone Pro Max width")
    func leagueFilteriPhoneProMaxWidth() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 430, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "iphone-pro-max-width-light"
        )
    }
    
    @Test("League filter - iPad width")
    func leagueFilteriPadWidth() async throws {
        let view = LeagueFilterView(
            leagues: sampleLeagues,
            selectedLeague: .constant(nil)
        )
        .frame(width: 768, height: 60)
        
        assertSnapshot(
            of: view,
            as: .image(precision: 0.99, perceptualPrecision: 0.98),
            named: "ipad-width-light"
        )
    }
}
