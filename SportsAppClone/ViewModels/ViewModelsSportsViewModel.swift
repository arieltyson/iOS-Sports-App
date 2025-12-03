//
//  SportsViewModel.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import Foundation
import Observation

/// Main view model for the Sports app
/// Uses the new @Observable macro for state management
@Observable
@MainActor
final class SportsViewModel {
    
    // MARK: - Published State
    
    private(set) var games: [Game] = []
    private(set) var leagues: [League] = []
    private(set) var favoriteTeams: [Team] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var selectedLeague: League?
    var searchText = ""
    
    // MARK: - Dependencies
    
    private let dataService: SportsDataService
    
    // MARK: - Initialization
    
    init(dataService: SportsDataService = .shared) {
        self.dataService = dataService
    }
    
    // MARK: - Computed Properties
    
    /// Filters games based on selected league and search text
    var filteredGames: [Game] {
        var filtered = games
        
        // Filter by selected league
        if let selectedLeague {
            filtered = filtered.filter { $0.leagueID == selectedLeague.id }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { game in
                game.homeTeam.fullName.localizedCaseInsensitiveContains(searchText) ||
                game.awayTeam.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    /// Groups games by their status
    var gamesByStatus: [GameStatus: [Game]] {
        Dictionary(grouping: filteredGames) { $0.status }
    }
    
    /// Live games for quick access
    var liveGames: [Game] {
        filteredGames.filter { $0.isLive }
    }
    
    /// Upcoming games
    var upcomingGames: [Game] {
        filteredGames
            .filter { $0.status == .scheduled }
            .sorted { $0.scheduledTime < $1.scheduledTime }
    }
    
    /// Final games
    var finalGames: [Game] {
        filteredGames
            .filter { $0.isFinal }
            .sorted { $0.scheduledTime > $1.scheduledTime }
    }
    
    // MARK: - Public Methods
    
    /// Loads all necessary data
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let gamesTask = dataService.fetchGames()
            async let leaguesTask = dataService.fetchLeagues()
            async let favoritesTask = dataService.fetchFavoriteTeams()
            
            // Execute all tasks concurrently
            let (fetchedGames, fetchedLeagues, fetchedFavorites) = try await (
                gamesTask,
                leaguesTask,
                favoritesTask
            )
            
            games = fetchedGames
            leagues = fetchedLeagues
            favoriteTeams = fetchedFavorites
            
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Refreshes the data
    func refresh() async {
        await loadData()
    }
    
    /// Toggles favorite status for a team
    func toggleFavorite(for team: Team) {
        if let index = favoriteTeams.firstIndex(where: { $0.id == team.id }) {
            favoriteTeams.remove(at: index)
        } else {
            var updatedTeam = team
            updatedTeam.isFavorite = true
            favoriteTeams.append(updatedTeam)
        }
    }
    
    /// Checks if a team is favorited
    func isFavorite(_ team: Team) -> Bool {
        favoriteTeams.contains(where: { $0.id == team.id })
    }
}
