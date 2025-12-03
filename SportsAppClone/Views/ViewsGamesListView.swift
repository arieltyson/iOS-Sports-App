//
//  GamesListView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// Main view displaying the list of games
struct GamesListView: View {
    @Bindable var viewModel: SportsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                // Live games section
                if !viewModel.liveGames.isEmpty {
                    gamesSection(
                        title: "Live Now",
                        games: viewModel.liveGames,
                        icon: "circle.fill",
                        iconColor: .red
                    )
                }
                
                // Upcoming games section
                if !viewModel.upcomingGames.isEmpty {
                    gamesSection(
                        title: "Upcoming",
                        games: viewModel.upcomingGames,
                        icon: "calendar"
                    )
                }
                
                // Final games section
                if !viewModel.finalGames.isEmpty {
                    gamesSection(
                        title: "Final",
                        games: viewModel.finalGames,
                        icon: "checkmark.circle.fill"
                    )
                }
                
                // Empty state
                if viewModel.filteredGames.isEmpty && !viewModel.isLoading {
                    emptyState
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search teams"
        )
    }
    
    // MARK: - Section Builder
    
    private func gamesSection(
        title: String,
        games: [Game],
        icon: String,
        iconColor: Color = .secondary
    ) -> some View {
        Section {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameCardView(game: game)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
            }
        } header: {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(iconColor)
                
                Text(title)
                    .font(.title3.weight(.semibold))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sportscourt")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("No Games Found")
                .font(.title2.weight(.semibold))
            
            Text("Try adjusting your filters or check back later")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GamesListView(viewModel: {
            let vm = SportsViewModel()
            Task { await vm.loadData() }
            return vm
        }())
    }
}
