/// Asserts only one of [path] or [routeId] is provided and not both.
void debugAssertOneOfPathOrRouteId(String? path, String? routeId) {
  assert(
    (path == null && routeId != null) || (path != null && routeId == null),
    'Either path or routeId must be specified, but not both.',
  );
}
