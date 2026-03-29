# GitHub User Explorer

An iOS app that searches GitHub users by username, displays their profile, and lets you navigate into followers/following lists recursively. Built with **Clean Architecture + MVVM**.

## Features

- Search GitHub users by username
- View full profile — avatar, name, bio, follower/following counts
- Browse followers and following lists with pagination
- Tap any user to view their profile (recursive navigation)
- Pull-to-refresh on user lists
- Skeleton loading screens
- Profile caching with CoreData (1-hour TTL)
- Network-first with cache fallback (Decorator + Composite pattern)

## Architecture

```
Domain                          (Layer 0 — zero dependencies)
  ├── Networking                (GitHub API client)
  ├── Persistence               (CoreData cache)
  ├── Presentation              (ViewModels)
  └── UI                        (SwiftUI views)
API_Infra                       (URLSession bridge)
App/                            (Composition Root — wires everything)
```

| Module | Responsibility |
|--------|---------------|
| **Domain** | Protocols (`GitHubUserService`, `FollowersService`, `FollowingService`) and models (`GitHubUser`, `UserSummary`) |
| **Networking** | Endpoints, DTOs, `RemoteStore`, `GitHubAPIService` |
| **API_Infra** | `URLSessionHTTPClient` conforming to `HTTPClient` |
| **Persistence** | CoreData `LocalStore`, `GitHubUserDAO` with cache-on-success |
| **Presentation** | `SearchUserViewModel`, `UserProfileViewModel`, `UserListViewModel` — state-machine pattern |
| **UI** | SwiftUI views, reusable components (skeleton, error/retry, not-found) |
| **App** | `AppFactory`, `Flow<Route>` navigation, Decorator + Composite wiring |

## Key Patterns

- **ViewModel State Machine** — Every VM uses `State: Equatable` enum (idle → isLoading → success/failure)
- **Decorator** — `GitHubUserServiceCacheDecorator` saves to cache on successful fetch
- **Composite** — `GitHubUserServiceWithFallbackComposite` falls back to cache on network failure
- **Constructor Injection** — All dependencies injected via initializers, no service locators
- **Closure-based pagination** — `UserListViewModel` takes a generic loader closure, reused for both followers and following

## GitHub API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /users/{username}` | Full user profile |
| `GET /users/{username}/followers?page=&per_page=` | Paginated followers list |
| `GET /users/{username}/following?page=&per_page=` | Paginated following list |

## Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5.9

## Setup

```bash
# Clone
git clone git@github.com:UI10/GIT-MVVM.git
cd GIT+MVVM

# Generate Xcode project (requires xcodegen)
brew install xcodegen
xcodegen generate

# Open in Xcode
open GIT+MVVM.xcodeproj
```

No API key required — the GitHub REST API allows unauthenticated requests (60 requests/hour rate limit).

## Tests

28 unit tests covering all layers:

| Layer | Tests | What's verified |
|-------|-------|-----------------|
| Networking | 13 | Endpoint URL construction, HTTP response mapping, error handling |
| Presentation | 16 | State transitions (idle → loading → success/failure), pagination, input trimming |
| Composition | 6 | Cache-on-success decorator, network-first fallback composite |

```bash
# Run tests via command line
xcodebuild test -project "GIT+MVVM.xcodeproj" -scheme "GIT+MVVM" \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro"
```

## Project Structure

```
├── Domain/
│   ├── User Profile Feature/   (GitHubUser, GitHubUserService, GitHubUserCache)
│   └── Followers Feature/      (UserSummary, FollowersService, FollowingService)
├── Networking/
│   ├── Endpoint/               (Endpoint protocol, UserEndpoint, FollowersEndpoint, FollowingEndpoint)
│   ├── Data/Responses/         (RemoteGitHubUser, RemoteUserSummary DTOs)
│   ├── RemoteStore.swift
│   └── GitHubAPIService.swift
├── API_Infra/
│   └── URLSessionHTTPClient.swift
├── Persistence/
│   ├── Cache/                  (LocalStore, CoreDataLocalStore, GitHubUserDAO)
│   └── Store.xcdatamodeld
├── Presentation/
│   ├── Search User/            (SearchUserViewModel)
│   ├── User Profile/           (UserProfileViewModel)
│   └── User List/              (UserListViewModel)
├── UI/
│   ├── Search/                 (SearchUserView)
│   ├── Profile/                (UserProfileView)
│   ├── User List/              (UserListView, UserSummaryRow)
│   └── Components/             (SkeletonView, ErrorRetryView, NotFoundView, ProfileStatButton)
├── App/
│   ├── GitHubExplorerApp.swift
│   ├── AppFactory.swift
│   ├── Navigation/             (Flow, SearchRoute, SearchFlowView)
│   └── Composition Helpers/    (CacheDecorator, FallbackComposite)
└── Tests/
    ├── Helpers/                (Spies, stubs, factory methods)
    ├── Networking/             (RemoteStoreTests, GitHubAPIServiceTests, EndpointTests)
    ├── Presentation/           (SearchUserVM, UserProfileVM, UserListVM tests)
    └── App/                    (Decorator + Composite tests)
```
