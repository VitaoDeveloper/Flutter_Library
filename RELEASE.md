# Release Notes

## Simple Library — Current Release

### Overview

This release turns the project into a more complete, polished, and maintainable Flutter library app. The main focus areas are API integration, UI/UX improvements, clearer error handling, documentation, and a fully English user interface.

> Release scope: changes reviewed from the previous stable app milestone (`24cefb2`) through the current branch state.

---

## Highlights

### English UI and Documentation

* Restored the full user interface to English, including app labels, dialogs, tooltips, snackbars, validation messages, loading states, empty states, and API error feedback.
* Translated the README to English and updated the documented project structure to match the current codebase.

### Modernized Interface

* Added a refreshed Material 3 visual identity with a purple/indigo color palette.
* Introduced a softer app background, rounded cards, floating snackbars, and styled input fields.
* Added a gradient AppBar for a stronger visual identity.
* Reworked the home layout using card-based sections for genre selection and search.
* Moved the add-book action next to the genre dropdown so the action is closer to its context.
* Improved book list items with card styling, rounded icons, and clearer action buttons.

### API Integration Improvements

* Added configurable API base URLs through Dart environment variables:
  * `LIBRARY_API_BASE_URL`
  * `LIBRARY_API_MUTATIONS_BASE_URL`
* Switched HTTP handling to Dio-based service calls.
* Updated create, edit, and delete request paths and payloads to better match the backend contract.
* Encoded resource names in mutation URLs to avoid failures caused by spaces or special characters.
* Added a functional reload flow that re-fetches all data from the backend and displays a loading interface while the request runs.

### User-Friendly Error Handling

* Centralized Dio error handling in `ApiErrors`.
* Added safer extraction of backend response messages.
* Mapped common HTTP statuses to plain-English user-facing messages.
* Added a specific conflict message for attempts to delete a genre that still contains books.

### Architecture and Maintainability

* Split UI responsibilities into reusable widgets.
* Moved business and API behavior into controller/service layers.
* Reduced duplicated reload logic by reusing a single refresh flow for startup and manual reload.
* Kept code identifiers in English for consistency and maintainability.

---

## Notable Changes by Area

### App Shell and Theme

* The app now uses a more polished Material 3 theme with custom color, card, snackbar, and input decoration settings.
* The app title is now `Library`.

### Home Screen

* UI strings are now English.
* The refresh button triggers a loading state and reloads all library data.
* The add-book button is now displayed inline next to the genre dropdown.
* Search and genre selection are visually grouped in cards.

### API Layer

* The API client supports build-time configuration with `String.fromEnvironment`.
* Library mutations support a separate base URL when needed.
* Edit payloads now send the expected update value.
* Path parameters are URL-encoded before mutation requests.

### Error Messages

* Errors are now written for end users instead of developers.
* Network, timeout, invalid data, not found, conflict, and server errors have clearer messages.

### README

* README content is now in English.
* Setup instructions and contribution guidance were translated.
* The project structure section was updated to reflect current files and folders.

---

## Migration Notes

If you need to target a custom backend, run the app with Dart defines:

```bash
flutter run \
  --dart-define=LIBRARY_API_BASE_URL=https://your-api.example.com \
  --dart-define=LIBRARY_API_MUTATIONS_BASE_URL=https://your-mutations-api.example.com
```

If both read and mutation endpoints share the same host, only `LIBRARY_API_BASE_URL` is required.

---

## Validation Checklist

Before publishing this release, validate:

* App startup loads all data from the backend.
* Manual reload displays loading and refreshes data.
* Book create, edit, and delete flows work.
* Genre create, edit, and delete flows work.
* Deleting a genre with books shows a clear conflict message.
* UI strings are English across the app.
* README instructions match the repository structure.

---
