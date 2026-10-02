# Accessibility

SportsAppClone is an iOS sports-reference app built with SwiftUI.

## Current implementation and checks

[Game cards](SportsAppClone/Views/ViewsComponentsGameCardView.swift) display
team names, scores, and game status as text, with semantic text styles for
most labels and system background colours.

The [snapshot test suite](SportsAppCloneTests/SnapshotTests) includes
larger-text cases for game cards, game lists, favourites, and league
filters, including light and dark appearances. Those tests exercise visual
states; they do not verify spoken output or task completion with a screen reader.

## Validation and limitations

Full accessibility support is not established by this statement. Verify
VoiceOver reading order and score context, filter selection, favourites,
loading and empty states, and navigation with Voice Control. Review the
largest text sizes and contrast on devices; some small team marks use a
fixed font size and team colours. Test motion and other display preferences
across the complete task.

## Report an accessibility problem

[Open an issue](https://github.com/arieltyson/iOS-Sports-App/issues/new) describing
the affected screen, steps to reproduce, expected and actual behaviour,
and the app version or commit. Include your device, iOS version, and
relevant assistive technology or accessibility settings.
