# CLAUDE.md — Notes iOS App

This file provides guidance for AI assistants working in this repository.

## Project Overview

A native iOS note-taking application built with UIKit and CoreData. The app allows users to create, edit, and delete notes with local persistence. There are no external dependencies — everything uses Apple's native frameworks.

- **Language**: Swift
- **UI Framework**: UIKit (programmatic, no Storyboards except LaunchScreen)
- **Persistence**: CoreData
- **Minimum deployment**: iOS 12.1
- **Architecture**: MVC with a protocol-driven data layer
- **Package manager**: None (no CocoaPods, SPM, or Carthage)

## Repository Structure

```
Notes-iOS-App/
├── Notes/                              # Main app source
│   ├── AppDelegate.swift               # App lifecycle, CoreData stack init
│   ├── ViewController.swift            # Root navigation controller + theming
│   ├── Core Data/                      # NSManagedObject subclass (Xcode-generated)
│   │   ├── Note+CoreDataClass.swift
│   │   └── Note+CoreDataProperties.swift
│   ├── CoreDataControllers/            # CRUD operations
│   │   └── NoteCoreDataController.swift
│   ├── Extensions/                     # UIKit utility extensions
│   │   ├── UIColor.swift               # UIColor → UIImage conversion
│   │   ├── UINavigationController.swift # Nav bar theming
│   │   └── UIView.swift                # Custom anchor() layout helper
│   ├── NotesTableViewController/       # Master list view
│   │   ├── NotesTableViewController.swift
│   │   └── NotesTableViewCell.swift
│   ├── NotesViewController/            # Detail / edit view
│   │   ├── NotesViewController.swift
│   │   └── NotesView.swift
│   ├── Protocols/
│   │   └── CoreDataDelegate.swift      # CRUD contract protocol
│   ├── Assets.xcassets/
│   ├── Notes.xcdatamodeld/             # CoreData model definition
│   ├── LaunchScreen.storyboard
│   └── Info.plist
├── NotesTests/                         # Unit test target (scaffolded, not implemented)
├── NotesUITests/                       # UI test target (scaffolded, not implemented)
├── Notes.xcodeproj/                    # Xcode project file
├── Assets/Images/Logo.png
└── README.md
```

## Architecture

### MVC Layer Responsibilities

| Layer | Files | Responsibility |
|-------|-------|----------------|
| Model | `Note+CoreData*.swift`, `Notes.xcdatamodeld` | Data entity definition |
| Data layer | `NoteCoreDataController.swift` | All CoreData CRUD via static methods |
| Controller | `NotesTableViewController`, `NotesViewController` | Business logic and UIKit glue |
| View | `NotesView`, `NotesTableViewCell` | Layout and display |
| App | `AppDelegate`, `ViewController` | Lifecycle, nav theming, CoreData stack |

### Data Flow

1. `AppDelegate` initialises `NSPersistentContainer` and saves context on app termination.
2. `NotesTableViewController` fetches and displays all notes sorted by title.
3. Selecting a note or tapping "+" pushes `NotesViewController` with an optional `Note?`.
4. `NotesViewController` writes changes to CoreData on dismissal via `NoteCoreDataController`.
5. The table view reloads after returning from the detail view.

### Protocol: `NoteCoreDataDelegate`

Defined in `Protocols/CoreDataDelegate.swift`. `NoteCoreDataController` implements it with static methods:
- `createNote(_:context:)` — inserts a new `Note` entity
- `updateNote(_:title:content:context:)` — updates an existing note
- `deleteNote(_:context:)` — deletes a note and saves context

Always go through `NoteCoreDataController` for persistence operations — do not call CoreData APIs directly from view controllers.

## Code Conventions

### Naming
- Types/classes: `PascalCase`
- Functions, variables, parameters: `camelCase`
- CoreData entity properties use `snake_case` (`created_at`, `last_update`, `reuse_id`) — keep this consistent when touching the model
- Test files follow the `<Target>Tests.swift` pattern

### Layout
- All layout is **programmatic** — do not use Storyboards or XIB files (except the existing `LaunchScreen.storyboard`)
- Use the custom `anchor()` extension on `UIView` (defined in `Extensions/UIView.swift`) instead of raw `NSLayoutConstraint` calls
- Always set `translatesAutoresizingMaskIntoConstraints = false` before applying constraints

### Theming
- Navigation bar theming is centralised in `Extensions/UINavigationController.swift` — add any nav bar appearance changes there, not in individual view controllers
- App accent colour: blue (`UIColor.systemBlue` / `#007AFF`)

### Static Utility Pattern
- `NoteCoreDataController` is used as a static utility class — do not instantiate it; add new data operations as additional `static` methods

### Error Handling
- Currently uses `print()` for non-fatal errors and `fatalError()` for unrecoverable CoreData failures
- Follow this existing pattern when adding new error handling; avoid introducing complex error propagation without discussing it first

## Development Workflow

### Building and Running
1. Open `Notes.xcodeproj` in Xcode
2. Select the `Notes` scheme and a simulator/device
3. Press `Cmd+R` to build and run

There is no command-line build script — all builds go through Xcode or `xcodebuild`.

### Running Tests
```bash
xcodebuild test -project Notes.xcodeproj -scheme Notes -destination 'platform=iOS Simulator,name=iPhone 14'
```
Note: Test targets exist (`NotesTests`, `NotesUITests`) but contain only template scaffolding with no actual test implementations. When adding new features, add corresponding tests.

### Branching
- Main stable branch: `master`
- Feature branches follow the pattern `claude/<description>` or `feature/<description>`
- There is no CI/CD pipeline — merges happen via pull requests manually reviewed

## Key Files to Understand First

When starting work in this codebase, read these files in order:

1. `Notes/Protocols/CoreDataDelegate.swift` — the data contract
2. `Notes/CoreDataControllers/NoteCoreDataController.swift` — how data is persisted
3. `Notes/AppDelegate.swift` — CoreData stack setup
4. `Notes/NotesTableViewController/NotesTableViewController.swift` — master list logic
5. `Notes/NotesViewController/NotesViewController.swift` — detail/edit logic
6. `Notes/Extensions/UIView.swift` — layout helper used everywhere

## What to Avoid

- Do not add external dependencies (CocoaPods, SPM packages, Carthage) without explicit discussion — the zero-dependency stance is intentional
- Do not use Storyboards or Interface Builder for new UI
- Do not call `managedObjectContext` directly from view controllers — use `NoteCoreDataController`
- Do not adopt SceneDelegate/multi-window APIs — the app intentionally targets iOS 12.1 and uses the single-window `AppDelegate` pattern
- Do not introduce a separate view model layer or reactive framework without a clear architectural discussion first
- The `Note+CoreData*.swift` files under `Core Data/` are Xcode-generated — prefer using the `setData()` helper in `Note+CoreDataProperties.swift` rather than setting individual properties manually

## CoreData Model

Single entity: **Note**

| Attribute | Type | Notes |
|-----------|------|-------|
| `title` | String | Displayed in table cell title |
| `content` | String | Body text of the note |
| `created_at` | Date | Set on creation |
| `last_update` | Date | Updated on every save |
| `reuse_id` | String | Used as table cell reuse identifier |

Changes to the model require a CoreData migration — create a new model version in `Notes.xcdatamodeld` rather than modifying the existing version.
