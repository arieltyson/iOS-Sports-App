//
//  FavoritesView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// View displaying user's favorite teams
struct FavoritesView: View {
    @Bindable var viewModel: SportsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.favoriteTeams.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.favoriteTeams) { team in
                        FavoriteTeamCard(team: team, viewModel: viewModel)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("My Teams")
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
                .symbolEffect(.pulse, options: .repeating)
            
            Text("No Favorite Teams")
                .font(.title2.weight(.semibold))
            
            Text("Tap the star on any team to add them to your favorites")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
}

// MARK: - Favorite Team Card

private struct FavoriteTeamCard: View {
    let team: Team
    let viewModel: SportsViewModel
    
    var body: some View {
        HStack {
            // Team logo
            Circle()
                .fill(Color(hex: team.primaryColor) ?? .gray)
                .frame(width: 48, height: 48)
                .overlay {
                    Text(team.abbreviation)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(team.fullName)
                    .font(.headline)
                
                if let league = viewModel.leagues.first(where: { $0.id == team.leagueID }) {
                    Text(league.abbreviation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation(.snappy) {
                    viewModel.toggleFavorite(for: team)
                }
            } label: {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FavoritesView(viewModel: {
            let vm = SportsViewModel()
            Task { await vm.loadData() }
            return vm
        }())
    }
}
