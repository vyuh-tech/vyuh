# Vyuh Feature Development Rules & Conventions

## Feature Structure
- Each feature should be in its own directory under `examples`
- Feature directory should contain:
  1. A Dart package for the feature implementation
  2. A schema package for Sanity schema definitions
- Package structure:
  ```
  examples/
    └── [feature_name]/           # e.g., conference/
        ├── feature_[name]/       # Dart package (e.g., feature_conference/)
        │   ├── lib/
        │   │   ├── api/         # API clients and data fetching
        │   │   ├── content/     # Content models
        │   │   ├── layouts/     # Layout configurations
        │   │   ├── widgets/     # Reusable widgets
        │   │   └── routes.dart  # Route definitions
        │   └── pubspec.yaml     # Dart dependencies
        │
        └── schema/              # NPM package for Sanity schema
            ├── src/
            │   ├── objects/     # Object type definitions
            │   └── index.ts     # Schema exports
            ├── package.json     # NPM dependencies
            └── tsconfig.json    # TypeScript configuration
  ```

## Schema Development (Sanity)
1. **Package Setup**
   - Initialize as an NPM package with `package.json`
   - Use TypeScript for type safety
   - Include Sanity as a peer dependency
   - Export schema through `index.ts`

2. **Type Naming**
   - Use `[feature].[type]` format for type names (e.g., `conf.edition`)
   - Keep type names lowercase and use dots for namespacing
   - Group related types under the same feature prefix

3. **Field Definitions**
   - Always include:
     - `title` field for display names
     - `slug` field for URLs/routing
     - `description` field for detailed text (optional)
   - Use `defineField` for field definitions
   - Use `defineType` for type definitions

4. **References**
   - Use `reference` type for relationships
   - Include `weak: true` for optional references
   - Define `to` array with allowed reference types

5. **Validation**
   - Add appropriate validation rules using `Rule`
   - Mark required fields with `validation: (Rule) => Rule.required()`

## Dart Implementation

### Content Models
1. **Class Structure**
   ```dart
   @JsonSerializable()
   class Conference extends ContentItem {
     static const schemaName = 'conf.conference';
     
     static final typeDescriptor = TypeDescriptor(
       schemaType: schemaName,
       fromJson: Conference.fromJson,
       title: 'Conference',
     );
     
     static final contentBuilder = ContentBuilder(
       content: typeDescriptor,
       defaultLayout: ConferenceLayout(),
       defaultLayoutDescriptor: ConferenceLayout.typeDescriptor,
     );
     
     @JsonKey(name: '_id')
     final String id;
     final String title;
     final String slug;
     
     const Conference({
       required this.id,
       required this.title,
       required this.slug,
     });
     
     factory Conference.fromJson(Map<String, dynamic> json) => 
       _$ConferenceFromJson(json);
   }
   ```

2. **Required Static Members**
   - `schemaName`: Matches the Sanity schema type name
   - `typeDescriptor`: Type information with:
     - `schemaType`: Schema type name
     - `fromJson`: JSON conversion function
     - `title`: Human-readable name
   - `contentBuilder`: Specifies:
     - `content`: Type descriptor
     - `defaultLayout`: Default layout instance
     - `defaultLayoutDescriptor`: Layout type descriptor

3. **Feature Registration**
   ```dart
   final feature = FeatureDescriptor(
     name: 'conference',
     title: 'Conference Feature',
     description: 'Conference feature description in detail',
     icon: Icons.event,
     init: () async {
       // Register feature dependencies
       vyuh.di.register(ConferenceApi(vyuh.content.provider));
     },
     extensions: [
       ContentExtensionDescriptor(contentBuilders: [
         Conference.contentBuilder,
       ]),
     ],
     routes: routes,
   );
   ```

### Layout Configuration
1. **Class Structure**
   ```dart
   @JsonSerializable()
   class MyLayout extends LayoutConfiguration {
     const MyLayout();
     
     factory MyLayout.fromJson(Map<String, dynamic> json) => 
       _$MyLayoutFromJson(json);
     
     @override
     Widget build(BuildContext context, MyContent content) {
       // Layout implementation
     }
   }
   ```

2. **Layout Guidelines**
   - Extend `LayoutConfiguration`
   - Keep layouts focused on presentation
   - Use `ContentImage` for image references
   - Implement responsive layouts using Flutter's layout system
   - Use theme colors and text styles for consistency

### UI Component Structure
1. **Widget Hierarchy**
   - Use `Column` with `crossAxisAlignment.start` for vertical layouts
   - Use `spacing` parameter instead of manual `SizedBox`
   - Prefer `ListTile` for title/subtitle combinations
   - Use `Card` for elevated content sections

2. **Padding & Spacing**
   - Use consistent padding (typically 16.0)
   - Use `SliverPadding` in scroll views
   - Maintain uniform spacing between sections

### Routing
1. **Route Structure**
   - Define routes in `routes.dart`
   - Use `GoRoute` for basic navigation
   - Use `StatefulShellRoute` for tabbed interfaces
   - Follow RESTful URL patterns

2. **Route Naming**
   - Use lowercase for path segments
   - Include IDs in path parameters
   - Structure: `/feature/:parentId/resource/:resourceId`

3. **Navigation**
   - Use `vyuh.router.go()` for navigation with state reset
   - Use `vyuh.router.push()` for navigation with state preservation
   - Include proper error handling and loading states

### API Integration
1. **API Client Structure**
   ```dart
   class MyApi {
     final SanityProvider _provider;
     
     Future<T?> getData() async {
       return _provider.fetchSingle(
         query,
         fromJson: T.fromJson,
       );
     }
   }
   ```

2. **Query Guidelines**
   - Write GROQ queries in multiline strings
   - Include proper type checking
   - Handle null values appropriately
   - Project only required fields

### State Management
1. **Scaffold Pattern**
   ```dart
   MyRouteScaffold<T>(
     errorTitle: 'Error Message',
     future: () => api.getData(),
     builder: (context, data) => widget,
   )
   ```

2. **Data Loading**
   - Use `FutureBuilder` for async data
   - Provide proper error handling
   - Show loading indicators
   - Enable refresh functionality

### Best Practices
1. **Code Organization**
   - Keep files focused and single-purpose
   - Use proper naming conventions
   - Implement proper error handling
   - Follow Flutter's style guide

2. **Performance**
   - Minimize unnecessary rebuilds
   - Use const constructors where possible
   - Implement pagination for large lists
   - Cache network resources appropriately

3. **Accessibility**
   - Use semantic labels
   - Ensure proper contrast
   - Support screen readers
   - Handle different text scales

4. **Testing**
   - Write unit tests for models
   - Write widget tests for layouts
   - Test error scenarios
   - Test navigation flows
