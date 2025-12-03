//
//  SportsDataService.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import Foundation

/// Service responsible for providing sports data
/// In a production app, this would fetch from a real API
@MainActor
final class SportsDataService {
    
    static let shared = SportsDataService()
    
    private init() {}
    
    // MARK: - Sample Data
    
    /// Sample leagues for demonstration
    private(set) lazy var leagues: [League] = [
        League(name: "National Football League", sport: .football, abbreviation: "NFL"),
        League(name: "National Basketball Association", sport: .basketball, abbreviation: "NBA"),
        League(name: "Major League Baseball", sport: .baseball, abbreviation: "MLB"),
        League(name: "National Hockey League", sport: .hockey, abbreviation: "NHL"),
        League(name: "Major League Soccer", sport: .soccer, abbreviation: "MLS")
    ]
    
    /// Sample teams for demonstration
    private(set) lazy var teams: [Team] = {
        var teamsArray: [Team] = []
        
        // NFL Teams
        let nflLeague = leagues.first(where: { $0.abbreviation == "NFL" })!
        teamsArray.append(contentsOf: [
            Team(name: "49ers", abbreviation: "SF", location: "San Francisco", primaryColor: "#AA0000", leagueID: nflLeague.id, isFavorite: true),
            Team(name: "Chiefs", abbreviation: "KC", location: "Kansas City", primaryColor: "#E31837", leagueID: nflLeague.id),
            Team(name: "Cowboys", abbreviation: "DAL", location: "Dallas", primaryColor: "#003594", leagueID: nflLeague.id),
            Team(name: "Eagles", abbreviation: "PHI", location: "Philadelphia", primaryColor: "#004C54", leagueID: nflLeague.id)
        ])
        
        // NBA Teams
        let nbaLeague = leagues.first(where: { $0.abbreviation == "NBA" })!
        teamsArray.append(contentsOf: [
            Team(name: "Warriors", abbreviation: "GSW", location: "Golden State", primaryColor: "#1D428A", leagueID: nbaLeague.id, isFavorite: true),
            Team(name: "Lakers", abbreviation: "LAL", location: "Los Angeles", primaryColor: "#552583", leagueID: nbaLeague.id),
            Team(name: "Celtics", abbreviation: "BOS", location: "Boston", primaryColor: "#007A33", leagueID: nbaLeague.id),
            Team(name: "Heat", abbreviation: "MIA", location: "Miami", primaryColor: "#98002E", leagueID: nbaLeague.id)
        ])
        
        return teamsArray
    }()
    
    /// Sample games for demonstration
    func games() -> [Game] {
        let now = Date()
        let calendar = Calendar.current
        
        var gamesArray: [Game] = []
        
        // NFL Games
        if let nflLeague = leagues.first(where: { $0.abbreviation == "NFL" }),
           let sf = teams.first(where: { $0.abbreviation == "SF" }),
           let kc = teams.first(where: { $0.abbreviation == "KC" }),
           let dal = teams.first(where: { $0.abbreviation == "DAL" }),
           let phi = teams.first(where: { $0.abbreviation == "PHI" }) {
            
            // Live game
            gamesArray.append(Game(
                homeTeam: sf,
                awayTeam: kc,
                homeScore: 21,
                awayScore: 17,
                status: .inProgress,
                scheduledTime: calendar.date(byAdding: .hour, value: -1, to: now)!,
                leagueID: nflLeague.id
            ))
            
            // Final game
            gamesArray.append(Game(
                homeTeam: phi,
                awayTeam: dal,
                homeScore: 28,
                awayScore: 24,
                status: .final,
                scheduledTime: calendar.date(byAdding: .hour, value: -3, to: now)!,
                leagueID: nflLeague.id
            ))
        }
        
        // NBA Games
        if let nbaLeague = leagues.first(where: { $0.abbreviation == "NBA" }),
           let gsw = teams.first(where: { $0.abbreviation == "GSW" }),
           let lal = teams.first(where: { $0.abbreviation == "LAL" }),
           let bos = teams.first(where: { $0.abbreviation == "BOS" }),
           let mia = teams.first(where: { $0.abbreviation == "MIA" }) {
            
            // Live game
            gamesArray.append(Game(
                homeTeam: gsw,
                awayTeam: lal,
                homeScore: 95,
                awayScore: 89,
                status: .inProgress,
                scheduledTime: calendar.date(byAdding: .minute, value: -45, to: now)!,
                leagueID: nbaLeague.id
            ))
            
            // Scheduled game
            gamesArray.append(Game(
                homeTeam: bos,
                awayTeam: mia,
                status: .scheduled,
                scheduledTime: calendar.date(byAdding: .hour, value: 2, to: now)!,
                leagueID: nbaLeague.id
            ))
        }
        
        return gamesArray
    }
    
    // MARK: - Public Methods
    
    /// Fetches games asynchronously (simulates network call)
    func fetchGames() async throws -> [Game] {
        // Simulate network delay
        try await Task.sleep(for: .milliseconds(500))
        return games()
    }
    
    /// Fetches leagues asynchronously
    func fetchLeagues() async throws -> [League] {
        try await Task.sleep(for: .milliseconds(300))
        return leagues
    }
    
    /// Fetches favorite teams
    func fetchFavoriteTeams() async throws -> [Team] {
        try await Task.sleep(for: .milliseconds(200))
        return teams.filter { $0.isFavorite }
    }
}
