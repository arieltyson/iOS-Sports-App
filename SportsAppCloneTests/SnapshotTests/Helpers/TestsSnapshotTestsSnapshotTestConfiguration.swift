//
//  SnapshotTestConfiguration.swift
//  SportsAppCloneTests
//
//  Created by Ariel Tyson on 3/12/25.
//

import Foundation
import SnapshotTesting

/// Global configuration for snapshot testing
/// This file should be loaded before running snapshot tests
@MainActor
enum SnapshotTestConfiguration {
    
    /// Configure snapshot testing settings
    static func configure() {
        // Set the default diffing tool (uncomment to use)
        // diffTool = "ksdiff"
        
        // Configure recording mode based on environment variable
        if ProcessInfo.processInfo.environment["SNAPSHOT_TESTING_RECORD"] == "1" {
            isRecording = true
        }
        
        // Set default precision for perceptual comparison
        // This can be overridden in individual tests
        SnapshotTesting.diffTool = getConfiguredDiffTool()
    }
    
    /// Returns the configured diff tool based on environment
    private static func getConfiguredDiffTool() -> String {
        // Check for custom diff tool in environment
        if let customTool = ProcessInfo.processInfo.environment["SNAPSHOT_DIFF_TOOL"] {
            return customTool
        }
        
        // Default to ksdiff if available
        return "ksdiff"
    }
    
    // MARK: - Test Configurations
    
    /// Standard precision for most UI tests
    static let standardPrecision: Float = 0.99
    static let standardPerceptualPrecision: Float = 0.98
    
    /// High precision for critical UI elements
    static let highPrecision: Float = 1.0
    static let highPerceptualPrecision: Float = 0.99
    
    /// Relaxed precision for dynamic content
    static let relaxedPrecision: Float = 0.95
    static let relaxedPerceptualPrecision: Float = 0.90
    
    // MARK: - Device Configurations
    
    /// Primary devices for comprehensive testing
    static let primaryDevices: [ViewImageConfig] = [
        .iPhone15Pro,
        .iPhone15ProMax,
        .iPhoneSE,
        .iPadPro11Inch
    ]
    
    /// Quick test devices for rapid iteration
    static let quickTestDevices: [ViewImageConfig] = [
        .iPhone15Pro
    ]
    
    // MARK: - Color Schemes
    
    /// Color schemes to test
    static let allColorSchemes: [ColorScheme] = [.light, .dark]
    
    // MARK: - Dynamic Type Sizes
    
    /// Standard dynamic type sizes to test
    static let standardDynamicTypeSizes: [ContentSizeCategory] = [
        .large,
        .accessibilityExtraLarge
    ]
    
    /// Comprehensive dynamic type sizes for accessibility testing
    static let comprehensiveDynamicTypeSizes: [ContentSizeCategory] = [
        .extraSmall,
        .small,
        .medium,
        .large,
        .extraLarge,
        .extraExtraLarge,
        .extraExtraExtraLarge,
        .accessibilityMedium,
        .accessibilityLarge,
        .accessibilityExtraLarge,
        .accessibilityExtraExtraLarge,
        .accessibilityExtraExtraExtraLarge
    ]
    
    // MARK: - Test Environment
    
    /// Checks if running in CI environment
    static var isRunningInCI: Bool {
        ProcessInfo.processInfo.environment["CI"] != nil ||
        ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] != nil ||
        ProcessInfo.processInfo.environment["XCODE_CLOUD"] != nil
    }
    
    /// Checks if recording mode is enabled
    static var isRecordingEnabled: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_TESTING_RECORD"] == "1"
    }
    
    /// Returns the current simulator name
    static var currentSimulatorName: String? {
        ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"]
    }
    
    // MARK: - Snapshot Naming
    
    /// Generates a consistent snapshot name
    static func snapshotName(
        base: String,
        device: String? = nil,
        colorScheme: ColorScheme? = nil,
        sizeCategory: ContentSizeCategory? = nil
    ) -> String {
        var components = [base]
        
        if let device {
            components.append(device)
        }
        
        if let colorScheme {
            components.append(colorScheme == .light ? "light" : "dark")
        }
        
        if let sizeCategory {
            components.append(accessibilitySizeSuffix(for: sizeCategory))
        }
        
        return components.joined(separator: "-")
    }
    
    /// Returns a suffix for accessibility size categories
    private static func accessibilitySizeSuffix(for category: ContentSizeCategory) -> String {
        switch category {
        case .extraSmall: return "xs"
        case .small: return "s"
        case .medium: return "m"
        case .large: return "l"
        case .extraLarge: return "xl"
        case .extraExtraLarge: return "xxl"
        case .extraExtraExtraLarge: return "xxxl"
        case .accessibilityMedium: return "ax-m"
        case .accessibilityLarge: return "ax-l"
        case .accessibilityExtraLarge: return "ax-xl"
        case .accessibilityExtraExtraLarge: return "ax-xxl"
        case .accessibilityExtraExtraExtraLarge: return "ax-xxxl"
        default: return "default"
        }
    }
    
    // MARK: - Utility Methods
    
    /// Prints configuration information (useful for debugging)
    static func printConfiguration() {
        print("""
        
        ═══════════════════════════════════════
        Snapshot Test Configuration
        ═══════════════════════════════════════
        CI Environment: \(isRunningInCI ? "Yes" : "No")
        Recording Mode: \(isRecordingEnabled ? "Yes" : "No")
        Simulator: \(currentSimulatorName ?? "Unknown")
        Diff Tool: \(diffTool ?? "Default")
        ═══════════════════════════════════════
        
        """)
    }
}

// MARK: - SwiftUI Extensions

import SwiftUI

extension View {
    /// Prepares a view for snapshot testing with standard configurations
    func preparedForSnapshot(
        colorScheme: ColorScheme = .light,
        sizeCategory: ContentSizeCategory = .large
    ) -> some View {
        self
            .environment(\.colorScheme, colorScheme)
            .environment(\.sizeCategory, sizeCategory)
    }
    
    /// Applies a fixed frame suitable for snapshot testing
    func snapshotFrame(
        width: CGFloat = 390,
        height: CGFloat = 844,
        alignment: Alignment = .center
    ) -> some View {
        self.frame(width: width, height: height, alignment: alignment)
    }
}

// MARK: - Custom Assertions

extension SnapshotTesting where Value: SwiftUI.View, Format == UIImage {
    
    /// Standard image snapshot with recommended precision
    static func standardImage() -> Snapshotting {
        .image(
            precision: SnapshotTestConfiguration.standardPrecision,
            perceptualPrecision: SnapshotTestConfiguration.standardPerceptualPrecision
        )
    }
    
    /// High precision image snapshot for critical UI
    static func criticalImage() -> Snapshotting {
        .image(
            precision: SnapshotTestConfiguration.highPrecision,
            perceptualPrecision: SnapshotTestConfiguration.highPerceptualPrecision
        )
    }
    
    /// Relaxed precision image snapshot for dynamic content
    static func dynamicImage() -> Snapshotting {
        .image(
            precision: SnapshotTestConfiguration.relaxedPrecision,
            perceptualPrecision: SnapshotTestConfiguration.relaxedPerceptualPrecision
        )
    }
}
