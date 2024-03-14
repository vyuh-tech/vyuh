## Core Principles

- Organize routes by a scheme and path, eg: <category>:<path>, similar to the
  way a URI is structured
- Stack routes
- Tab routes
- Nested routes
- Relative routes
- Custom transitions
- Hygienic routes on web with fragment routing by default
- Route redirection
- Unknown route handling
- Regex path matches
- Path parameters
- Dynamic route injection
- Deferred routes
- Route guards
- Pop handler
- Navigation push, pop, replace with conditions
- Route queueing
- Route modules
- Named slots

## route map of a super app

`(<domain>:)?<path>` by default the scope is set to global: `$global:`

### Travel

Known namespaces: $global, food, grocery and others that have been registered by
features.

- /travel/home ==> travel://home
- /home ==> $global://home
- /slp ==> $global://slp
- /grocery/slp ==> grocery://slp
