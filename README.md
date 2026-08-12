# Rick and Morty App

An iOS app that lists characters from the Rick and Morty universe and displays detailed information about each one.

The project was built with UIKit and View Code, focusing on separation of concerns, testability, and maintainability.

## Features

- Character listing
- Infinite scrolling
- Local character search
- Empty state when no characters are found
- Character details
- First appearance information fetched from the episode API
- Local cache with a configurable TTL
- Disk image caching
- Loading and error states
- Retry support for recoverable errors
- Navigation managed by an App Coordinator

## Architecture

The project is organized into three main layers:

- **Presentation:** Views, View Controllers, Presenters, Interactors, View Models, and navigation contracts
- **Domain:** Entities, repository contracts, and Use Cases
- **Data:** DTOs, Data Sources, repository implementations, requests, mappers, and cache

Shared components are located under `Core`, including networking, persistence, image loading, error handling, and View Code utilities.
<img width="277" height="441" alt="Screenshot 2026-08-12 at 01 58 33" src="https://github.com/user-attachments/assets/c31b6ba4-efef-4e8e-bbd8-083e5ee1140a" />


## Navigation

Navigation is centralized in `AppCoordinator`.

The coordinator owns the navigation controller, starts the Home flow, opens the Details screen, and handles the return navigation. Feature modules depend only on routing protocols, keeping UIKit navigation calls outside their View Controllers.
<img width="727" height="466" alt="Screenshot 2026-08-12 at 02 01 27" src="https://github.com/user-attachments/assets/00a06e71-2562-4129-8e60-008117c1fadf" />


## Networking

The networking layer uses typed API requests and isolates Alamofire behind internal abstractions.
<img width="1349" height="336" alt="Screenshot 2026-08-12 at 02 06 15" src="https://github.com/user-attachments/assets/768666e0-5ff8-4177-9524-7fad6bcf9bb3" />


This structure allows networking tests to run without performing real HTTP requests.

## Local cache

Only the first page of characters is persisted locally.

When the app starts:

1. The repository checks for valid cached data.
2. If the cache is valid, the local response is returned.
3. If the cache is missing or expired, the API is called.
4. The remote response is persisted and returned.

The cache has a configurable TTL, currently set to two minutes.

Persisting only the first page improves the initial loading experience while keeping the cache small and predictable. Additional pages are loaded remotely through pagination.

## Error handling

Infrastructure errors are mapped into application-level errors before reaching the Presentation layer.

Recoverable failures, such as connectivity issues and timeouts, allow the user to retry. Non-recoverable failures display an appropriate message without offering an action that cannot succeed.

On the Details screen, an episode request failure affects only the “First seen in” section. Character information received from Home remains visible.

## Trade-offs

### File-based cache

The first page of characters is persisted as a JSON file in the application cache directory.

This approach was selected because the cached response is small, replaceable, and does not require queries, relationships, migrations, or partial updates.

Alternatives such as Core Data or SwiftData would provide more advanced persistence capabilities, but would add unnecessary complexity for a single cached response with a short TTL.

The file cache is not treated as a permanent source of truth. The operating system may remove it, and the app must always be able to fetch the data again.

### First-page persistence

Only the first page is persisted locally.

The first page provides the highest value because it is displayed when the app starts. Persisting every paginated response would require additional rules for page invalidation, ordering, duplication, and partial cache expiration.

Pagination therefore remains remote-only.

### Configurable TTL

The character cache uses a configurable TTL, currently set to two minutes.

A short TTL improves the initial loading experience without keeping potentially outdated data for too long. The TTL is injected into the cache policy, allowing it to change without modifying repository behavior.

### Local search

Search is performed against the characters already loaded in memory.

This avoids additional network requests and provides immediate feedback. The trade-off is that search results are limited to the pages loaded during the current session rather than the complete remote character catalog.

### Episode request on Details

Most character information is passed from Home to Details. Only the first episode information is fetched remotely.

This prevents an unnecessary character request when opening Details while still retrieving the episode name, code, and air date from their source endpoint.

If the episode request fails, the remaining character information stays available.

### Image caching

Character images are cached using Kingfisher in memory and on disk.

This improves scrolling and navigation performance, but introduces an external dependency. The image-loading behavior remains isolated from the Domain and Data layers.

### Coordinator navigation

Navigation is centralized in `AppCoordinator`.

This keeps push and pop operations outside View Controllers and makes navigation behavior testable. For the current application size, a single coordinator is sufficient. If the number of flows grows, it can be split into child coordinators.

### Retry policy

Automatic retry with exponential backoff was intentionally not added.

Retrying every failed request could increase traffic and delay user feedback. Recoverable failures currently expose an explicit retry action, keeping the behavior predictable.

An automatic policy can be introduced later if production requirements show that transient failures are frequent enough to justify it.

## Swift Package Manager dependencies

External dependencies are managed with Swift Package Manager through the Xcode project.

### Alamofire

Repository:

```text
https://github.com/Alamofire/Alamofire.git
```

Minimum version:

```text
5.12.0
```

Alamofire is used as the HTTP transport implementation. It is isolated behind `HTTPSession` and `HTTPTransport` abstractions so the rest of the application does not depend directly on Alamofire.

This also allows networking tests to use spies and stubs instead of performing real requests.

### Kingfisher

Repository:

```text
https://github.com/onevcat/Kingfisher.git
```

Minimum version:

```text
8.11.0
```

Kingfisher is responsible for asynchronous image loading and image caching.

Its disk cache expiration is configured with the same TTL used by the first-page character cache.

No manual dependency installation is required.

## Tests

Unit tests are written with Swift Testing.

The test suite covers:

- API requests and response decoding
- HTTP transport and API client
- Data Sources and repositories
- DTO-to-domain mapping
- Cache behavior and expiration
- Use Cases and Interactors
- Presenters and View Model mappers
- Search and pagination
- Error mapping
- Coordinator navigation

Test doubles and fixtures are kept in separate files to keep test cases focused.

## Running the project

1. Clone the repository.
2. Open `RickAndMortyApp.xcodeproj`.
3. Wait for Swift Package Manager to resolve the dependencies.
4. Select an iOS Simulator.
5. Build and run the app.

No API key or additional configuration is required.

## API

Data is provided by the public [Rick and Morty API](https://rickandmortyapi.com/).
