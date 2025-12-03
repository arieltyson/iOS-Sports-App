//
//  GameCardView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// Displays a game card with team information and scores
struct GameCardView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 0) {
            // Status header
            HStack {
                StatusBadge(status: game.status)
                Spacer()
                TimeLabel(game: game)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            
            // Teams and scores
            VStack(spacing: 12) {
                TeamScoreRow(
                    team: game.awayTeam,
                    score: game.awayScore,
                    isWinning: isWinning(team: game.awayTeam)
                )
                
                Divider()
                    .padding(.horizontal, 16)
                
                TeamScoreRow(
                    team: game.homeTeam,
                    score: game.homeScore,
                    isWinning: isWinning(team: game.homeTeam)
                )
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Helper Methods
    
    private func isWinning(team: Team) -> Bool {
        guard let homeScore = game.homeScore,
              let awayScore = game.awayScore else {
            return false
        }
        
        if team.id == game.homeTeam.id {
            return homeScore > awayScore
        } else {
            return awayScore > homeScore
        }
    }
}

// MARK: - Supporting Views

/// Displays the game status badge
private struct StatusBadge: View {
    let status: GameStatus
    
    var body: some View {
        Text(status.displayText)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
    
    private var textColor: Color {
        switch status {
        case .inProgress: return .white
        case .final: return .secondary
        case .scheduled: return .secondary
        case .postponed: return .orange
        }
    }
    
    private var backgroundColor: Color {
        switch status {
        case .inProgress: return .red
        case .final: return Color(.systemGray5)
        case .scheduled: return Color(.systemGray5)
        case .postponed: return Color.orange.opacity(0.2)
        }
    }
}

/// Displays the game time or status
private struct TimeLabel: View {
    let game: Game
    
    var body: some View {
        Text(timeText)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    private var timeText: String {
        switch game.status {
        case .scheduled:
            return game.scheduledTime.formatted(date: .omitted, time: .shortened)
        case .inProgress:
            return "In Progress"
        case .final:
            return "Final"
        case .postponed:
            return "Postponed"
        }
    }
}

/// Displays a team with their score
private struct TeamScoreRow: View {
    let team: Team
    let score: Int?
    let isWinning: Bool
    
    var body: some View {
        HStack {
            // Team logo placeholder
            Circle()
                .fill(Color(hex: team.primaryColor) ?? .gray)
                .frame(width: 32, height: 32)
                .overlay {
                    Text(team.abbreviation)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            
            // Team name
            VStack(alignment: .leading, spacing: 2) {
                Text(team.location)
                    .font(.subheadline.weight(isWinning ? .semibold : .regular))
                Text(team.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Score
            if let score {
                Text("\(score)")
                    .font(.title2.weight(isWinning ? .bold : .regular))
                    .foregroundStyle(isWinning ? .primary : .secondary)
                    .monospacedDigit()
            } else {
                Text("—")
                    .font(.title3)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initializes a Color from a hex string
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview("Live Game") {
    GameCardView(game: Game(
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
    .padding()
}

#Preview("Scheduled Game") {
    GameCardView(game: Game(
        homeTeam: Team(
            name: "Warriors",
            abbreviation: "GSW",
            location: "Golden State",
            primaryColor: "#1D428A",
            leagueID: UUID()
        ),
        awayTeam: Team(
            name: "Lakers",
            abbreviation: "LAL",
            location: "Los Angeles",
            primaryColor: "#552583",
            leagueID: UUID()
        ),
        status: .scheduled,
        scheduledTime: Date().addingTimeInterval(7200),
        leagueID: UUID()
    ))
    .padding()
}
