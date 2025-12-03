//
//  ContentView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// Root view of the Sports app
/// Implements a tab-based navigation structure with games and favorites
struct ContentView: View {
    @State private var viewModel = SportsViewModel()
    @State private var selectedTab: Tab = .games
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Games tab
            NavigationStack {
                gamesTab
            }
            .tabItem {
                Label("Games", systemImage: "sportscourt.fill")
            }
            .tag(Tab.games)
            
            // Favorites tab
            NavigationStack {
                FavoritesView(viewModel: viewModel)
            }
            .tabItem {
                Label("My Teams", systemImage: "star.fill")
            }
            .tag(Tab.favorites)
        }
        .task {
            await viewModel.loadData()
        }
    }
    
    // MARK: - Games Tab
    
    private var gamesTab: some View {
        VStack(spacing: 0) {
            // League filter
            LeagueFilterView(
                leagues: viewModel.leagues,
                selectedLeague: $viewModel.selectedLeague
            )
            
            Divider()
            
            // Games list
            GamesListView(viewModel: viewModel)
                .navigationTitle("Games")
                .navigationDestination(for: Game.self) { game in
                    GameDetailView(game: game)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        refreshButton
                    }
                }
                .overlay {
                    if viewModel.isLoading {
                        loadingOverlay
                    }
                }
        }
    }
    
    // MARK: - Supporting Views
    
    private var refreshButton: some View {
        Button {
            Task {
                await viewModel.refresh()
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .symbolEffect(.rotate, value: viewModel.isLoading)
        }
        .disabled(viewModel.isLoading)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.8)
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Loading games...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .transition(.opacity)
    }
}

// MARK: - Tab Enumeration

private enum Tab: Hashable {
    case games
    case favorites
}

// MARK: - Preview

#Preview("Content View") {
    ContentView()
}

#Preview("Games Tab") {
    NavigationStack {
        ContentView()
    }
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
} 
