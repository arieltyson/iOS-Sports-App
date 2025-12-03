//
//  GameDetailView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// Detailed view for a single game
struct GameDetailView: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with status
                statusHeader
                
                // Main score display
                scoreDisplay
                
                // Game information
                gameInfo
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Components
    
    private var statusHeader: some View {
        HStack {
            StatusBadge(status: game.status)
            
            Spacer()
            
            if game.status == .inProgress {
                HStack(spacing: 4) {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    Text("LIVE")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    private var scoreDisplay: some View {
        VStack(spacing: 32) {
            // Away team
            TeamScoreDisplay(
                team: game.awayTeam,
                score: game.awayScore,
                isHome: false
            )
            
            // VS divider
            Text("vs")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
            
            // Home team
            TeamScoreDisplay(
                team: game.homeTeam,
                score: game.homeScore,
                isHome: true
            )
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var gameInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Game Information")
                .font(.headline)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                InfoRow(title: "Date", value: game.scheduledTime.formatted(date: .long, time: .omitted))
                Divider().padding(.horizontal, 16)
                InfoRow(title: "Time", value: game.scheduledTime.formatted(date: .omitted, time: .shortened))
                Divider().padding(.horizontal, 16)
                InfoRow(title: "Status", value: game.status.displayText)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Supporting Views

private struct StatusBadge: View {
    let status: GameStatus
    
    var body: some View {
        Text(status.displayText)
            .font(.caption.weight(.semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
    
    private var textColor: Color {
        status == .inProgress ? .white : .secondary
    }
    
    private var backgroundColor: Color {
        status == .inProgress ? .red : Color(.systemGray5)
    }
}

private struct TeamScoreDisplay: View {
    let team: Team
    let score: Int?
    let isHome: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Team logo
            Circle()
                .fill(Color(hex: team.primaryColor) ?? .gray)
                .frame(width: 80, height: 80)
                .overlay {
                    Text(team.abbreviation)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                }
            
            // Team name
            VStack(spacing: 4) {
                Text(team.location)
                    .font(.title3.weight(.semibold))
                Text(team.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Score
            if let score {
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold))
                    .monospacedDigit()
            } else {
                Text("—")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(.tertiary)
            }
            
            // Home indicator
            if isHome {
                Text("HOME")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
        }
    }
}

private struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(16)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GameDetailView(game: Game(
            homeTeam: Team(
                name: "49ers",
                abbreviation: "SF",
                location: "San Francisco",
                primaryColor: "#AA0000",
                leagueID: UUID()
            ),
            awayTeam: Team(
                name: "Chiefs",
                abbreviation: "KC",
                location: "Kansas City",
                primaryColor: "#E31837",
                leagueID: UUID()
            ),
            homeScore: 21,
            awayScore: 17,
            status: .inProgress,
            scheduledTime: Date(),
            leagueID: UUID()
        ))
    }
}
