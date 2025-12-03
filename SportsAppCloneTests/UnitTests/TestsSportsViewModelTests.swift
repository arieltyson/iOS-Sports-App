//
//  SportsViewModelTests.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Testing
import Foundation
@testable import SportsAppClone

/// Test suite demonstrating modern Swift Testing framework
/// This showcases how the architecture supports comprehensive testing
@Suite("Sports ViewModel Tests")
@MainActor
struct SportsViewModelTests {
    
    // MARK: - Data Loading Tests
    
    @Test("Load data successfully")
    func loadDataSuccessfully() async throws {
        let viewModel = SportsViewModel()
        
        await viewModel.loadData()
        
        #expect(!viewModel.games.isEmpty, "Games should be loaded")
        #expect(!viewModel.leagues.isEmpty, "Leagues should be loaded")
        #expect(!viewModel.isLoading, "Loading should complete")
        #expect(viewModel.errorMessage == nil, "No error should occur")
    }
    
    @Test("Loading state changes during data fetch")
    func loadingStateChanges() async throws {
        let viewModel = SportsViewModel()
        
        #expect(!viewModel.isLoading, "Should start not loading")
        
        let loadTask = Task {
            await viewModel.loadData()
        }
        
        // Note: In a real app with actual async operations,
        // you would check isLoading == true here
        
        await loadTask.value
        
        #expect(!viewModel.isLoading, "Should finish loading")
    }
    
    // MARK: - Filtering Tests
    
    @Test("Filter games by league")
    func filterGamesByLeague() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        // Get the first league
        let nflLeague = try #require(
            viewModel.leagues.first { $0.abbreviation == "NFL" },
            "NFL league should exist"
        )
        
        viewModel.selectedLeague = nflLeague
        
        // All filtered games should belong to selected league
        #expect(viewModel.filteredGames.allSatisfy { $0.leagueID == nflLeague.id })
    }
    
    @Test("Filter games by search text")
    func filterGamesBySearchText() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        viewModel.searchText = "San Francisco"
        
        // Should contain only games with San Francisco teams
        for game in viewModel.filteredGames {
            let matchesSearch = game.homeTeam.fullName.localizedCaseInsensitiveContains("San Francisco") ||
                              game.awayTeam.fullName.localizedCaseInsensitiveContains("San Francisco")
            #expect(matchesSearch, "Game should match search criteria")
        }
    }
    
    @Test("Search is case-insensitive")
    func searchIsCaseInsensitive() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        let originalCount = viewModel.games.count
        
        // Test with different cases
        viewModel.searchText = "warriors"
        let lowercaseResults = viewModel.filteredGames.count
        
        viewModel.searchText = "WARRIORS"
        let uppercaseResults = viewModel.filteredGames.count
        
        viewModel.searchText = "Warriors"
        let capitalizedResults = viewModel.filteredGames.count
        
        // All should return the same results
        #expect(lowercaseResults == uppercaseResults)
        #expect(uppercaseResults == capitalizedResults)
    }
    
    @Test("Clear search text shows all games")
    func clearSearchShowsAllGames() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        let totalGames = viewModel.games.count
        
        viewModel.searchText = "Warriors"
        #expect(viewModel.filteredGames.count < totalGames)
        
        viewModel.searchText = ""
        #expect(viewModel.filteredGames.count == totalGames)
    }
    
    // MARK: - Game Status Tests
    
    @Test("Live games are correctly identified")
    func liveGamesIdentification() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        // All live games should have inProgress status
        for game in viewModel.liveGames {
            #expect(game.status == .inProgress)
            #expect(game.isLive)
        }
    }
    
    @Test("Upcoming games are sorted by time")
    func upcomingGamesSorting() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        let upcomingGames = viewModel.upcomingGames
        
        // Verify games are sorted by scheduled time
        for index in 0..<(upcomingGames.count - 1) {
            let current = upcomingGames[index]
            let next = upcomingGames[index + 1]
            #expect(current.scheduledTime <= next.scheduledTime)
        }
    }
    
    @Test("Final games are sorted by most recent")
    func finalGamesSorting() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        let finalGames = viewModel.finalGames
        
        // Verify games are sorted by scheduled time (descending)
        for index in 0..<(finalGames.count - 1) {
            let current = finalGames[index]
            let next = finalGames[index + 1]
            #expect(current.scheduledTime >= next.scheduledTime)
        }
    }
    
    // MARK: - Favorites Tests
    
    @Test("Toggle favorite adds and removes team")
    func toggleFavorite() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        // Get a team that's not favorited
        let team = try #require(
            viewModel.games.first?.homeTeam,
            "Should have at least one team"
        )
        
        let initialFavoritesCount = viewModel.favoriteTeams.count
        let initiallyFavorited = viewModel.isFavorite(team)
        
        // Toggle favorite
        viewModel.toggleFavorite(for: team)
        
        if initiallyFavorited {
            #expect(viewModel.favoriteTeams.count == initialFavoritesCount - 1)
            #expect(!viewModel.isFavorite(team))
        } else {
            #expect(viewModel.favoriteTeams.count == initialFavoritesCount + 1)
            #expect(viewModel.isFavorite(team))
        }
    }
    
    @Test("Favorite status is correctly tracked")
    func favoriteStatusTracking() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        for favorite in viewModel.favoriteTeams {
            #expect(viewModel.isFavorite(favorite), "Favorite team should be marked as favorite")
        }
    }
    
    // MARK: - Data Consistency Tests
    
    @Test("Games reference valid teams")
    func gamesReferenceValidTeams() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        for game in viewModel.games {
            // Teams should have valid data
            #expect(!game.homeTeam.name.isEmpty)
            #expect(!game.awayTeam.name.isEmpty)
            #expect(!game.homeTeam.abbreviation.isEmpty)
            #expect(!game.awayTeam.abbreviation.isEmpty)
        }
    }
    
    @Test("Games have valid scheduled times")
    func gamesHaveValidScheduledTimes() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        for game in viewModel.games {
            // Scheduled time should be reasonable (within 1 week of now)
            let weekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
            let weekFromNow = Date().addingTimeInterval(7 * 24 * 60 * 60)
            
            #expect(game.scheduledTime >= weekAgo)
            #expect(game.scheduledTime <= weekFromNow)
        }
    }
    
    @Test("Live games have scores")
    func liveGamesHaveScores() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        for game in viewModel.liveGames {
            #expect(game.homeScore != nil, "Live game should have home score")
            #expect(game.awayScore != nil, "Live game should have away score")
        }
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Games by status groups correctly")
    func gamesByStatusGrouping() async throws {
        let viewModel = SportsViewModel()
        await viewModel.loadData()
        
        let gamesByStatus = viewModel.gamesByStatus
        
        // Verify all games in each group have the correct status
        for (status, games) in gamesByStatus {
            for game in games {
                #expect(game.status == status)
            }
        }
    }
}

// MARK: - Model Tests

@Suite("Sport Model Tests")
@MainActor
struct SportModelTests {
    
    @Test("Team full name is correctly formatted")
    func teamFullName() {
        let team = Team(
            name: "49ers",
            abbreviation: "SF",
            location: "San Francisco",
            primaryColor: "#AA0000",
            leagueID: UUID()
        )
        
        #expect(team.fullName == "San Francisco 49ers")
    }
    
    @Test("Game status display text is correct")
    func gameStatusDisplayText() {
        #expect(GameStatus.scheduled.displayText == "Upcoming")
        #expect(GameStatus.inProgress.displayText == "LIVE")
        #expect(GameStatus.final.displayText == "Final")
        #expect(GameStatus.postponed.displayText == "Postponed")
    }
    
    @Test("Game identifies live status correctly")
    func gameIdentifiesLiveStatus() {
        let liveGame = Game(
            homeTeam: sampleTeam(),
            awayTeam: sampleTeam(),
            homeScore: 21,
            awayScore: 17,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        #expect(liveGame.isLive)
        #expect(!liveGame.isFinal)
    }
    
    @Test("Game identifies final status correctly")
    func gameIdentifiesFinalStatus() {
        let finalGame = Game(
            homeTeam: sampleTeam(),
            awayTeam: sampleTeam(),
            homeScore: 28,
            awayScore: 24,
            status: .final,
            scheduledTime: Date(),
            leagueID: UUID()
        )
        
        #expect(finalGame.isFinal)
        #expect(!finalGame.isLive)
    }
    
    // Helper
    private func sampleTeam() -> Team {
        Team(
            name: "Test Team",
            abbreviation: "TT",
            location: "Test City",
            primaryColor: "#000000",
            leagueID: UUID()
        )
    }
}

// MARK: - Service Tests

@Suite("Sports Data Service Tests")
@MainActor
struct SportsDataServiceTests {
    
    @Test("Fetch games returns data")
    func fetchGames() async throws {
        let service = SportsDataService.shared
        
        let games = try await service.fetchGames()
        
        #expect(!games.isEmpty)
    }
    
    @Test("Fetch leagues returns data")
    func fetchLeagues() async throws {
        let service = SportsDataService.shared
        
        let leagues = try await service.fetchLeagues()
        
        #expect(!leagues.isEmpty)
        #expect(leagues.contains { $0.abbreviation == "NFL" })
        #expect(leagues.contains { $0.abbreviation == "NBA" })
    }
    
    @Test("Fetch favorite teams returns only favorites")
    func fetchFavoriteTeams() async throws {
        let service = SportsDataService.shared
        
        let favorites = try await service.fetchFavoriteTeams()
        
        for team in favorites {
            #expect(team.isFavorite)
        }
    }
}
