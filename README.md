 021 Trade — Watchlist Flutter App

A Flutter application built for the **021 Trade Flutter Developer Assignment**. The app implements a stock watchlist with drag-and-drop position swapping, powered by the **BLoC (Business Logic Component)** architecture pattern.

 Assignment Requirements Fulfilled

| Requirement | Status |
|---|---|
| Watchlist UI with multiple stocks |  Done |
| Swap/reorder stock positions | Done via drag-and-drop |
| BLoC architecture pattern |  Full Events → BLoC → States implementation |
| Sample data structure for stocks |  `SampleData` class with 10 NSE stocks |
| UI/UX quality |  Dark trading theme, animations, shimmer loading |
| Responsiveness |  Adapts to various screen sizes, portrait lock |
| Code quality & reusability |  Separated widgets, single responsibility per file |
| Type safety |  `Equatable`, enums, `copyWith`, no dynamic types |
| Correct BLoC components |  Events, States, Bloc, BlocProvider, BlocBuilder |
| Project structuring |  Feature-based folder separation |

---

 My Approach

Why BLoC?
The assignment specifically required BLoC. BLoC separates **UI** from **business logic** cleanly — the watchlist screen never directly modifies data; it only dispatches events and reacts to state. This makes the code predictable, testable, and scalable.

How the Reorder Works
When a user drags a stock tile to a new position, Flutter's `ReorderableListView` fires an `onReorder` callback with the old and new indices. I convert that into a `WatchlistReordered` event which the BLoC handles by:
1. Cloning the current stock list
2. Removing the item from `oldIndex`
3. Inserting it at the adjusted `newIndex`
4. Emitting the new state with the updated order

The UI rebuilds automatically via `BlocBuilder`, showing the updated order instantly — no manual setState anywhere.

### Edit Mode Design
Rather than always showing drag handles (which clutters the UI), I added a toggleable **Edit Mode**:
- **Normal mode** → clean list view with sparkline charts visible
- **Edit mode** → drag handles appear, remove (−) buttons appear per row, sparklines hide to save space

This mirrors how the iOS Stocks app handles watchlist reordering — a familiar UX pattern for finance apps.

### Data Flow

```
User Action
    │
    ▼
UI dispatches Event
    │
    ▼
WatchlistBloc receives Event
    │
    ├── WatchlistLoaded          → loads SampleData, emits success state
    ├── WatchlistReordered       → reorders stock list, emits new state
    ├── WatchlistStockRemoved    → filters list by id, emits new state
    └── WatchlistEditModeToggled → flips isEditMode bool, emits new state
    │
    ▼
New WatchlistState emitted
    │
    ▼
BlocBuilder rebuilds only the affected widgets
```

---

## Project Structure

```
lib/
│
├── main.dart
│     App entry point. Sets up BlocProvider with WatchlistBloc,
│     fires WatchlistLoaded on start, applies dark theme,
│     locks orientation to portrait.
│
├── bloc/
│   ├── watchlist_bloc.dart
│   │     The core BLoC. Registers handlers for all 4 events
│   │     and emits new WatchlistState on each. Uses Dart's
│   │     'part' system to keep events & state co-located.
│   │
│   ├── watchlist_event.dart  (part of watchlist_bloc.dart)
│   │     All possible user/system actions as sealed event classes:
│   │     WatchlistLoaded, WatchlistReordered,
│   │     WatchlistStockRemoved, WatchlistEditModeToggled
│   │
│   └── watchlist_state.dart  (part of watchlist_bloc.dart)
│         Single WatchlistState class with status enum
│         (initial/loading/success/failure), stocks list,
│         isEditMode flag, and optional errorMessage.
│
├── models/
│   └── stock.dart
│         The Stock data model. Extends Equatable for value equality.
│         Has copyWith(), a private named constructor, and StockTrend
│         enum (up/down/neutral) auto-derived from the change field.
│
├── screens/
│   ├── watchlist_screen.dart
│   │     Main screen with custom AppBar. BlocBuilder switches
│   │     between: shimmer (loading), error view, empty view,
│   │     normal list view, and reorderable list (edit mode).
│   │
│   ├── watchlist_shimmer.dart
│   │     Skeleton loading UI built with AnimationController —
│   │     no external shimmer package needed.
│   │
│   ├── watchlist_empty.dart
│   │     Shown when all stocks are removed from the watchlist.
│   │
│   └── watchlist_error.dart
│         Shown on data load failure. Has a Retry button that
│         re-dispatches WatchlistLoaded to the BLoC.
│
├── widgets/
│   ├── stock_tile.dart
│   │     The core reusable tile. Shows symbol avatar, company name,
│   │     exchange badge, mini sparkline, price, and trend badge.
│   │     In edit mode: shows drag handle + remove (−) button.
│   │
│   ├── trend_badge.dart
│   │     Reusable coloured pill showing % change with directional
│   │     icon. Green for gains, red for losses, grey for flat.
│   │
│   └── mini_spark.dart
│         Decorative sparkline chart per stock tile drawn with
│         CustomPainter. Includes a gradient fill under the line.
│         No external chart library used.
│
├── theme/
│   └── app_theme.dart
│         All colour constants (AppColors) and ThemeData config.
│         Dark trading palette: #0A0E1A background, #111827 cards,
│         #00E676 for gains, #FF3D57 for losses.
│
└── utils/
    ├── sample_data.dart
    │     Static list of 10 NSE stocks (Reliance, TCS, HDFC, etc.)
    │     representing the watchlist data structure. Simulates what
    │     would be a repository/API layer in a production app.
    │
    └── formatters.dart
          Pure utility functions: Indian number format for prices
          (₹2,947.55), signed change (+42.30), percent (+1.46%),
          and volume in millions (12.4M).
```

---

##  BLoC — Events & State Reference

### Events

| Event | Payload | When it fires |
|---|---|---|
| `WatchlistLoaded` | — | App starts — triggers initial data fetch |
| `WatchlistReordered` | `oldIndex: int, newIndex: int` | User completes a drag-and-drop reorder |
| `WatchlistStockRemoved` | `stockId: String` | User taps the (−) button in edit mode |
| `WatchlistEditModeToggled` | — | User taps Edit or Done in the AppBar |

### State Shape

```dart
WatchlistState {
  WatchlistStatus status,   // initial | loading | success | failure
  List<Stock> stocks,       // current ordered list of stocks
  bool isEditMode,          // true = drag mode, false = view mode
  String? errorMessage,     // populated only on failure
}
```

### State Transitions

```
WatchlistLoaded
  → emits status: loading
  → awaits simulated 600ms fetch
  → emits status: success, stocks: [10 NSE stocks]

WatchlistReordered(oldIndex: 2, newIndex: 0)
  → clones the current list
  → removes item at index 2
  → inserts it at adjusted index 0
  → emits new stocks order (status and mode unchanged)

WatchlistStockRemoved(stockId: 'TCS')
  → filters out the stock where id == 'TCS'
  → emits updated stocks list

WatchlistEditModeToggled
  → flips isEditMode: false → true (or true → false)
  → BlocBuilder switches between normal list and ReorderableListView
```

---

##  Stock Data Model

```dart
class Stock extends Equatable {
  final String id;            // unique identifier
  final String symbol;        // e.g. "RELIANCE"
  final String companyName;   // e.g. "Reliance Industries Ltd."
  final double price;         // current price in INR
  final double change;        // absolute change e.g. +42.30
  final double changePercent; // percent change e.g. +1.46
  final StockTrend trend;     // auto-derived: up | down | neutral
  final String exchange;      // e.g. "NSE"
  final double volume;        // trading volume in millions
}
```

`StockTrend` is **automatically derived** from `change` inside the constructor — there is no risk of mismatch between the numeric value and the displayed trend direction.

Sample watchlist includes: RELIANCE, TCS, HDFCBANK, INFY, ICICIBANK, HINDUNILVR, SBIN, BHARTIARTL, WIPRO, MARUTI — a mix of gainers, losers, and flat stocks.

---

##  Design Decisions & Reasoning

**Dark Trading Theme** — Chosen because trading apps are used for extended sessions. Dark backgrounds reduce eye strain and make the green/red gain-loss indicators visually pop without competing colours around them.

**No Third-Party Drag Library** — Flutter's built-in `ReorderableListView` handles drag physics, touch targets, and accessibility natively. Adding an external library would have introduced unnecessary complexity and a heavier dependency tree.

**Custom Shimmer (no package)** — Built using `AnimationController` and opacity animation directly. This keeps the dependency list minimal and gives full control over animation speed and styling.

**Custom Sparklines (no chart library)** — `CustomPainter` draws the mini sparkline with a gradient fill. A full charting library would be overkill for a decorative 55×30px element.

**proxyDecorator on Drag** — When a tile is being dragged, it scales up to 1.03× and reduces to 0.92 opacity. This gives clear "picked up" visual feedback, making the interaction feel physical.

**Edit / Done Toggle** — Reorder mode is opt-in, not always visible. This keeps the normal watchlist clean and distraction-free, and is consistent with how Apple Stocks and Robinhood handle list reordering.

**Haptic Feedback** — `selectionClick` on reorder and `mediumImpact` on remove gives physical confirmation of actions on real devices — an important detail for a trading app where accidental taps have consequences.

**Indian Number Format** — Prices are formatted in the Indian system (₹2,947.55, ₹11,842.20) rather than Western grouping, matching what NSE-listed stocks would display locally.

---

##  Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Run the app

```bash
git clone https://github.com/<your-username>/021trade-watchlist.git
cd 021trade-watchlist
flutter pub get
flutter run
```

### Build release APK

```bash
flutter build apk --release
```

---

##  Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.5 | BLoC state management |
| `equatable` | ^2.0.5 | Value equality for models & states |
| `google_fonts` | ^6.2.1 | Space Grotesk typography |

Everything else — shimmer loading, sparklines, Indian price formatting — is custom-built with no external dependencies.

---

##  Code Quality Highlights

- All BLoC states and events extend `Equatable` — prevents unnecessary UI rebuilds on identical states
- `copyWith()` on both `Stock` and `WatchlistState` — all state updates are fully immutable
- `const` constructors used wherever possible — reduces widget tree rebuilds
- `part` / `part of` — events and state are co-located with the BLoC file for easier navigation
- Dart 3 `switch` expressions — exhaustive enum handling, compiler catches any missing case
- Every widget has a single responsibility — `StockTile` only renders, `WatchlistBloc` only decides
- Zero business logic inside widgets — all decisions flow through BLoC events
- `dispose()` called on every `AnimationController` — no memory leaks

---

*Built for the 021 Trade Flutter Developer Assignment.*  
*Submission: Vikas p shetty
