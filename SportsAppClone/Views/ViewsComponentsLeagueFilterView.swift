//
//  LeagueFilterView.swift
//  SportsAppClone
//
//  Created by Ariel Tyson on 3/12/25.
//

import SwiftUI

/// Horizontal scrolling filter for leagues
struct LeagueFilterView: View {
    let leagues: [League]
    @Binding var selectedLeague: League?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "All" filter chip
                FilterChip(
                    title: "All Sports",
                    isSelected: selectedLeague == nil
                ) {
                    withAnimation(.snappy) {
                        selectedLeague = nil
                    }
                }
                
                // League filter chips
                ForEach(leagues) { league in
                    FilterChip(
                        title: league.abbreviation,
                        icon: league.sport.iconName,
                        isSelected: selectedLeague?.id == league.id
                    ) {
                        withAnimation(.snappy) {
                            if selectedLeague?.id == league.id {
                                selectedLeague = nil
                            } else {
                                selectedLeague = league
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Filter Chip

/// Individual filter chip component
private struct FilterChip: View {
    let title: String
    var icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption.weight(.semibold))
                }
                
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        LeagueFilterView(
            leagues: [
                League(name: "National Football League", sport: .football, abbreviation: "NFL"),
                League(name: "National Basketball Association", sport: .basketball, abbreviation: "NBA"),
                League(name: "Major League Baseball", sport: .baseball, abbreviation: "MLB")
            ],
            selectedLeague: .constant(nil)
        )
        Spacer()
    }
}
