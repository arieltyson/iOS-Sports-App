//
//  Sport.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import Foundation

/// Represents different sports categories available in the app
enum SportType: String, Codable, CaseIterable, Identifiable {
    case football = "Football"
    case basketball = "Basketball"
    case baseball = "Baseball"
    case hockey = "Hockey"
    case soccer = "Soccer"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .football: return "football.fill"
        case .basketball: return "basketball.fill"
        case .baseball: return "baseball.fill"
        case .hockey: return "hockey.puck.fill"
        case .soccer: return "soccerball"
        }
    }
}

/// Represents a sports league
struct League: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let sport: SportType
    let abbreviation: String
    
    init(id: UUID = UUID(), name: String, sport: SportType, abbreviation: String) {
        self.id = id
        self.name = name
        self.sport = sport
        self.abbreviation = abbreviation
    }
}

/// Represents a team within a league
struct Team: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let abbreviation: String
    let location: String
    let primaryColor: String
    let leagueID: UUID
    var isFavorite: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        abbreviation: String,
        location: String,
        primaryColor: String,
        leagueID: UUID,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.location = location
        self.primaryColor = primaryColor
        self.leagueID = leagueID
        self.isFavorite = isFavorite
    }
    
    var fullName: String {
        "\(location) \(name)"
    }
}

/// Represents a game/match between two teams
struct Game: Identifiable, Codable, Hashable {
    let id: UUID
    let homeTeam: Team
    let awayTeam: Team
    let homeScore: Int?
    let awayScore: Int?
    let status: GameStatus
    let scheduledTime: Date
    let leagueID: UUID
    
    init(
        id: UUID = UUID(),
        homeTeam: Team,
        awayTeam: Team,
        homeScore: Int? = nil,
        awayScore: Int? = nil,
        status: GameStatus,
        scheduledTime: Date,
        leagueID: UUID
    ) {
        self.id = id
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.status = status
        self.scheduledTime = scheduledTime
        self.leagueID = leagueID
    }
    
    var isLive: Bool {
        status == .inProgress
    }
    
    var isFinal: Bool {
        status == .final
    }
}

/// Game status enumeration
enum GameStatus: String, Codable, Hashable {
    case scheduled = "Scheduled"
    case inProgress = "Live"
    case final = "Final"
    case postponed = "Postponed"
    
    var displayText: String {
        switch self {
        case .scheduled: return "Upcoming"
        case .inProgress: return "LIVE"
        case .final: return "Final"
        case .postponed: return "Postponed"
        }
    }
}
