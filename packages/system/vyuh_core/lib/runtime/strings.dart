import 'package:flutter/foundation.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Every user-facing string the framework shows: failure titles and
/// messages, recovery actions and accessibility labels.
///
/// Set it once on [PlatformWidgetBuilder.strings] to translate or reword:
///
/// ```dart
/// PlatformWidgetBuilder.system.copyWith(
///   strings: const VyuhStrings(
///     tryAgain: 'Réessayer',
///     goHome: 'Accueil',
///   ),
/// )
/// ```
///
/// For a locale that changes at runtime, build the strings from your
/// localizations wherever you create the widget builder.
@immutable
final class VyuhStrings {
  /// Retry button.
  final String tryAgain;

  /// Go-home button.
  final String goHome;

  /// Restart button, the last-resort recovery.
  final String restartApp;

  /// Heading of the debug-only details panel.
  final String details;

  /// Accessibility label of loaders.
  final String loading;

  /// Accessibility label of the placeholder for a widget that failed to build.
  final String contentUnavailable;

  /// Title when the app fails to start.
  final String appStartFailedTitle;

  /// Message when the app fails to start.
  final String appStartFailedMessage;

  /// Title when no route matches, or a page does not exist.
  final String pageNotFoundTitle;

  /// Message when no route matches [location].
  final String Function(Uri location) noRouteMessage;

  /// Title when a page could not be loaded.
  final String pageLoadFailedTitle;

  /// Title when content inside a page does not exist.
  final String contentNotFoundTitle;

  /// Title when content inside a page could not be loaded.
  final String contentLoadFailedTitle;

  /// Message for failures that a retry may fix.
  final String checkConnectionMessage;

  /// Message for something that is missing.
  final String missingMessage;

  /// Title when the lazy feature titled [featureTitle] fails to load.
  final String Function(String featureTitle) featureLoadFailedTitle;

  /// Title when the lazy feature titled [featureTitle] is turned off.
  final String Function(String featureTitle) featureDisabledTitle;

  /// Message when a lazy feature is turned off.
  final String featureDisabledMessage;

  const VyuhStrings({
    this.tryAgain = 'Try again',
    this.goHome = 'Go home',
    this.restartApp = 'Restart app',
    this.details = 'Details (debug only)',
    this.loading = 'Loading',
    this.contentUnavailable = 'Content unavailable',
    this.appStartFailedTitle = 'The app could not start',
    this.appStartFailedMessage = 'Something went wrong while starting up.',
    this.pageNotFoundTitle = 'Page not found',
    this.noRouteMessage = _noRouteMessage,
    this.pageLoadFailedTitle = 'This page could not be loaded',
    this.contentNotFoundTitle = 'Content not found',
    this.contentLoadFailedTitle = 'This content could not be loaded',
    this.checkConnectionMessage = 'Check your connection and try again.',
    this.missingMessage = 'It may have been moved or removed.',
    this.featureLoadFailedTitle = _featureLoadFailedTitle,
    this.featureDisabledTitle = _featureDisabledTitle,
    this.featureDisabledMessage =
        'This part of the app is turned off right now.',
  });

  static String _noRouteMessage(Uri location) =>
      'Nothing is available at $location.';
  static String _featureLoadFailedTitle(String title) =>
      'Could not load $title';
  static String _featureDisabledTitle(String title) =>
      '$title is not available';

  /// The strings of the running app, or the defaults when none is running.
  static VyuhStrings get current {
    try {
      return VyuhBinding.instance.widgetBuilder.strings;
    } catch (_) {
      return const VyuhStrings();
    }
  }
}
