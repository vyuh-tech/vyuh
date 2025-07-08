import 'package:flutter/foundation.dart';

/// The base type for all extension descriptors.
/// An ExtensionDescriptor provides configurability for an extension.
abstract class ExtensionDescriptor {
  /// The title of the extension.
  final String title;

  String? _sourceFeature;

  /// The name of the feature which this extension belongs to.
  /// This is set by the Vyuh bootstrapping process
  String? get sourceFeature => _sourceFeature;

  /// Sets the source feature for this extension.
  /// This is called by the Vyuh bootstrapping process.
  void setSourceFeature(String featureName) {
    _sourceFeature = featureName;

    onSourceFeatureUpdated();
  }

  /// Creates a new ExtensionDescriptor.
  ExtensionDescriptor({
    required this.title,
  });

  void onSourceFeatureUpdated();
}

/// The base type for all extension builders. An extension builder is responsible for building an extension,
/// by assembling all of the extension descriptors.
abstract class ExtensionBuilder<T extends ExtensionDescriptor> {
  /// The title of the extension.
  final String title;

  /// The runtime Type of the extension.
  final Type extensionType;

  bool _isInitialized = false;
  bool _isDisposed = false;

  String? _sourceFeature;

  /// The name of the feature which this extension belongs to.
  /// This is set by the bootstrapping process of Vyuh.
  String? get sourceFeature => _sourceFeature;

  /// Sets the source feature for this extension builder.
  /// This is called by the Vyuh bootstrapping process.
  @mustCallSuper
  void setSourceFeature(String featureName) {
    _sourceFeature = featureName;
  }

  /// Creates a new ExtensionBuilder.
  ExtensionBuilder({
    required this.extensionType,
    required this.title,
  });

  /// Whether the extension is currently initialized.
  bool get isInitialized => _isInitialized;

  /// Whether the extension has been disposed.
  bool get isDisposed => _isDisposed;

  /// Protected method for subclasses to implement initialization logic.
  @protected
  Future<void> onInit(List<T> extensions) async {}

  /// Protected method for subclasses to implement disposal logic.
  @protected
  Future<void> onDispose() async {}

  /// Initializes the extension.
  @nonVirtual
  Future<void> init(List<ExtensionDescriptor> extensions) async {
    if (_isInitialized) {
      throw StateError('Extension $title is already initialized');
    }

    try {
      await onInit(extensions.whereType<T>().toList());
      _isInitialized = true;
      _isDisposed = false;
    } catch (_) {
      // Let the platform handle the error
      rethrow;
    }
  }

  /// Disposes the extension.
  @nonVirtual
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    try {
      await onDispose();
    } finally {
      _isDisposed = true;
      _isInitialized = false;
    }
  }
}
