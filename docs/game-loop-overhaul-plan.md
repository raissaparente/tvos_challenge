# Stop TV Game Loop and Host Role Overhaul

## Summary

Implement this as a phased overhaul. Phase 1 fixes gameplay correctness and connectivity state sync. Phase 2 cleans architecture around role-based navigation and message handling. Phase 3 improves readability/efficiency. Phase 4 extends hosting so any iPhone/iPad can choose Host or Player after entering a name, while tvOS remains display/host-oriented for now.

## Key Changes

- Replace device-idiom role selection with an explicit role choice after `SetNameViewController`: `Host` starts browsing/inviting, `Player` starts advertising/waiting.
- Keep existing UIKit screens, but rename behavior internally from TV/Phone assumptions toward Host/Player where touched.
- Introduce a single game-state source for round index, category index, drawn letter, categories, answers, votes, and players.
- Ensure all host-to-player transitions send the data needed before navigation:
    - categories before category screen
    - full answer set before voting screen
    - next category or ranking/end state after voting
    - round reset before next round
- Fix scoring to validate answers against the actual drawn round letter, case/diacritic-insensitive, not by drawing a new random letter.
- Prevent duplicate answer/vote submissions by tracking player names/peer IDs per category with sets or keyed dictionaries.

## Implementation Plan

### Phase 1: Game Loop Fixes

- Fix `MatchManager` round indexing: rounds start at `0`, last round is `currentRound >= maxRoundsCount - 1`, reset returns to `0`, and `currentLetter` bounds-checks safely.
- Store the drawn letter once per round and use it everywhere, including labels and scoring.
- Send `setAnswers` before `.startVote` so clients can render voting reliably.
- Change waiting behavior so `.endVote` does not blindly navigate players to answer entry; it should react to explicit next states such as next category, partial ranking, or final ranking.
- Replace answer/vote count checks with unique player checks.

### Phase 2: Architecture Cleanup

- Add a lightweight `AppRole` enum: `.host`, `.player`.
- Add a role-selection screen after name entry for iPhone/iPad.
- Update `AppCoordinator` to start from `AppRole` instead of `UIDevice.userInterfaceIdiom`.
- Centralize incoming `GameAction` handling so `ConnectionManager` decodes messages and forwards events, while view models own game mutations.
- Prefer one status enum; retire or ignore the unused duplicate status model.

### Phase 3: Code Efficiency and Readability

- Remove duplicate target/action setup in `SetNameViewController`.
- Fix typos like `setAnsers`.
- Remove unused mock/debug paths where they affect production screens.
- Replace force unwraps in gameplay UI with guarded fallbacks for missing assets/data.
- Keep comments only where they explain non-obvious flow.

### Phase 4: Host Any iOS Device

- Host role on iPhone/iPad uses the existing host flow and Multipeer browsing/inviting.
- Player role on iPhone/iPad uses the existing player flow and advertising/invite acceptance.
- Host screens should use adaptive constraints where needed, but this pass does not redesign every screen for ideal phone-host layout.
- tvOS keeps current display/host behavior and does not need player role support in this plan.

## Test Plan

- Build the Xcode project.
- Unit-test round progression:
    - round 1 starts at index `0`
    - final round detection works for `maxRoundsCount = 2`
    - reset returns to round `0`
    - current letter never indexes past `letters`
- Unit-test answer validation:
    - matching first letter passes case-insensitively
    - non-matching first letter fails
    - empty answer fails
- Manual two-device scenarios:
    - iPhone host invites iPhone player
    - iPad host invites iPhone player
    - all players answer, then all see voting with the same answers
    - duplicate answer/vote does not advance or double-count
    - after last category, players do not return to answer screen while host shows ranking
    - next round clears old categories, answers, votes, and player submission state

## Assumptions

- First implementation keeps UIKit and existing screen designs.
- "Host can be any device" means any iPhone/iPad can host; tvOS stays host/display-only for this overhaul.
- Valid answers must start with the drawn letter, ignoring case and accents.
- The first pass prioritizes correctness and state sync over a full visual redesign.
