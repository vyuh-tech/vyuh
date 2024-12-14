/// Asserts only one of [path] or [routeId] is provided and not both.
/// Asserts that only one of [path] or [routeId] is provided.
///
/// This method checks the following conditions:
/// - Either [path] is `null` and [routeId] is not `null`.
/// - OR [path] is not `null` and [routeId] is `null`.
///
/// If both [path] and [routeId] are provided or neither is specified,
/// an `AssertionError` will be thrown in debug mode.
///
/// Example:
/// ```dart
/// debugAssertOneOfPathOrRouteId('/home', null); // Valid.
/// debugAssertOneOfPathOrRouteId(null, 'route_123'); // Valid.
/// debugAssertOneOfPathOrRouteId('/home', 'route_123'); // Fails in debug mode.
/// debugAssertOneOfPathOrRouteId(null, null); // Fails in debug mode.
/// ```
///
/// @param [path] An optional string representing the route path.
/// @param [routeId] An optional string representing the route ID.
void debugAssertOneOfPathOrRouteId(String? path, String? routeId) {
  assert(
    (path == null && routeId != null) || (path != null && routeId == null),
    'Either path or routeId must be specified, but not both.',
  );
}
