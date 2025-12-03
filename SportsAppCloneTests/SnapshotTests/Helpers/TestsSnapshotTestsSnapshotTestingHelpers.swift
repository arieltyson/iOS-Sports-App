//
//  SnapshotTestingHelpers.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI
import SnapshotTesting
@testable import SportsAppClone

/// Provides utilities and configurations for snapshot testing
@MainActor
enum SnapshotTestingHelpers {
    
    // MARK: - Device Configurations
    
    /// Standard device configurations for snapshot testing
    enum DeviceConfig {
        case iPhone15Pro
        case iPhone15ProMax
        case iPhoneSE
        case iPadPro11
        case iPadPro13
        
        var viewImageConfig: ViewImageConfig {
            switch self {
            case .iPhone15Pro:
                return .iPhone15Pro
            case .iPhone15ProMax:
                return .iPhone15ProMax
            case .iPhoneSE:
                return .iPhoneSE
            case .iPadPro11:
                return .iPadPro11Inch
            case .iPadPro13:
                return .iPadPro13Inch
            }
        }
        
        var name: String {
            switch self {
            case .iPhone15Pro: return "iPhone15Pro"
            case .iPhone15ProMax: return "iPhone15ProMax"
            case .iPhoneSE: return "iPhoneSE"
            case .iPadPro11: return "iPadPro11"
            case .iPadPro13: return "iPadPro13"
            }
        }
    }
    
    // MARK: - Color Scheme Configurations
    
    /// Color scheme variations for testing
    enum ColorSchemeVariant {
        case light
        case dark
        case both
        
        var schemes: [ColorScheme] {
            switch self {
            case .light: return [.light]
            case .dark: return [.dark]
            case .both: return [.light, .dark]
            }
        }
    }
    
    // MARK: - Content Size Category
    
    /// Dynamic type size configurations
    enum DynamicTypeSize {
        case `default`
        case accessibilityExtraLarge
        case accessibilityExtraExtraLarge
        
        var sizeCategory: ContentSizeCategory {
            switch self {
            case .default: return .large
            case .accessibilityExtraLarge: return .accessibilityExtraLarge
            case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
            }
        }
        
        var name: String {
            switch self {
            case .default: return "Default"
            case .accessibilityExtraLarge: return "AXL"
            case .accessibilityExtraExtraLarge: return "AXXL"
            }
        }
    }
    
    // MARK: - Mock Data Generation
    
    /// Creates sample leagues for testing
    static func createMockLeagues() -> [League] {
        [
            League(name: "National Football League", sport: .football, abbreviation: "NFL"),
            League(name: "National Basketball Association", sport: .basketball, abbreviation: "NBA"),
            League(name: "Major League Baseball", sport: .baseball, abbreviation: "MLB"),
            League(name: "National Hockey League", sport: .hockey, abbreviation: "NHL"),
            League(name: "Major League Soccer", sport: .soccer, abbreviation: "MLS")
        ]
    }
    
    /// Creates sample teams for testing
    static func createMockTeams() -> [Team] {
        let leagues = createMockLeagues()
        
        return [
            // NFL Teams
            Team(
                name: "49ers",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#AA0000",
                leagueID: leagues[0].id
            ),
            Team(
                name: "Chiefs",
                abbreviation: "KC",
                location: "Kansas City",
                primaryColor: "#E31837",
                leagueID: leagues[0].id
            ),
            Team(
                name: "Cowboys",
                abbreviation: "DAL",
                location: "Dallas",
                primaryColor: "#003594",
                leagueID: leagues[0].id
            ),
            
            // NBA Teams
            Team(
                name: "Warriors",
                abbreviation: "GSW",
                location: "Golden State",
                primaryColor: "#1D428A",
                leagueID: leagues[1].id
            ),
            Team(
                name: "Lakers",
                abbreviation: "LAL",
                location: "Los Angeles",
                primaryColor: "#552583",
                leagueID: leagues[1].id
            ),
            Team(
                name: "Celtics",
                abbreviation: "BOS",
                location: "Boston",
                primaryColor: "#007A33",
                leagueID: leagues[1].id
            ),
            
            // MLB Teams
            Team(
                name: "Giants",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#FD5A1E",
                leagueID: leagues[2].id
            ),
            Team(
                name: "Yankees",
                abbreviation: "NYY",
                location: "New York",
                primaryColor: "#003087",
                leagueID: leagues[2].id
            )
        ]
    }
    
    /// Creates sample games for testing
    static func createMockGames() -> [Game] {
        let teams = createMockTeams()
        let leagues = createMockLeagues()
        
        let now = Date()
        let twoHoursFromNow = now.addingTimeInterval(7200)
        let yesterday = now.addingTimeInterval(-86400)
        
        return [
            // Live game
            Game(
                homeTeam: teams[0],
                awayTeam: teams[1],
                homeScore: 21,
                awayScore: 17,
                status: .inProgress,
                scheduledTime: now.addingTimeInterval(-3600),
                leagueID: leagues[0].id
            ),
            
            // Another live game
            Game(
                homeTeam: teams[3],
                awayTeam: teams[4],
                homeScore: 98,
                awayScore: 102,
                status: .inProgress,
                scheduledTime: now.addingTimeInterval(-1800),
                leagueID: leagues[1].id
            ),
            
            // Upcoming game
            Game(
                homeTeam: teams[2],
                awayTeam: teams[0],
                status: .scheduled,
                scheduledTime: twoHoursFromNow,
                leagueID: leagues[0].id
            ),
            
            // Another upcoming game
            Game(
                homeTeam: teams[5],
                awayTeam: teams[3],
                status: .scheduled,
                scheduledTime: twoHoursFromNow.addingTimeInterval(3600),
                leagueID: leagues[1].id
            ),
            
            // Final game
            Game(
                homeTeam: teams[6],
                awayTeam: teams[7],
                homeScore: 5,
                awayScore: 3,
                status: .final,
                scheduledTime: yesterday,
                leagueID: leagues[2].id
            ),
            
            // Another final game
            Game(
                homeTeam: teams[1],
                awayTeam: teams[2],
                homeScore: 28,
                awayScore: 31,
                status: .final,
                scheduledTime: yesterday.addingTimeInterval(-3600),
                leagueID: leagues[0].id
            ),
            
            // Postponed game
            Game(
                homeTeam: teams[4],
                awayTeam: teams[5],
                status: .postponed,
                scheduledTime: now.addingTimeInterval(7200),
                leagueID: leagues[1].id
            )
        ]
    }
    
    /// Creates a mock view model with test data
    static func createMockViewModel(
        withFavorites: Bool = false,
        selectedLeague: League? = nil,
        searchText: String = ""
    ) -> SportsViewModel {
        let viewModel = SportsViewModel()
        
        // Manually set the data using reflection or by creating a testable initializer
        // For this example, we'll need to ensure the view model can be initialized with data
        // In a production app, you'd create a protocol-based service that can be mocked
        
        return viewModel
    }
    
    // MARK: - Snapshot Configuration
    
    /// Default snapshot configuration
    static var defaultConfig: (
        precision: Float,
        perceptualPrecision: Float
    ) {
        (precision: 0.99, perceptualPrecision: 0.98)
    }
    
    /// Creates a configured view for snapshot testing
    static func prepareViewForSnapshot<Content: View>(
        _ view: Content,
        colorScheme: ColorScheme,
        sizeCategory: ContentSizeCategory = .large
    ) -> some View {
        view
            .environment(\.colorScheme, colorScheme)
            .environment(\.sizeCategory, sizeCategory)
    }
}

// MARK: - Custom Snapshot Strategies

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    
    /// Creates a snapshot strategy for multiple devices and color schemes
    @MainActor
    static func devices(
        _ configs: [SnapshotTestingHelpers.DeviceConfig],
        colorSchemes: [ColorScheme] = [.light, .dark]
    ) -> [(name: String, config: Snapshotting)] {
        configs.flatMap { device in
            colorSchemes.map { scheme in
                let name = "\(device.name)-\(scheme == .light ? "light" : "dark")"
                let config = Snapshotting.image(
                    layout: .device(config: device.viewImageConfig),
                    traits: .init(userInterfaceStyle: scheme == .light ? .light : .dark)
                )
                return (name: name, config: config)
            }
        }
    }
}
