# Neon Tasks

A premium Flutter todo app with a cyber-dark UI: neon accents, glassmorphism, smooth animations, and local task persistence.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.13+-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.1+-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey" alt="Platform" />
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License" />
</p>

---

## About

**Neon Tasks** is a task manager with a modern cyberpunk / premium SaaS look: deep violet backgrounds, acid green accents, fluid transitions, and intuitive gestures.

---

## Screenshots

<p align="center">
  <img src="docs/screenshots/home-mobile.png" alt="Home screen" width="280" />
  &nbsp;&nbsp;
  <img src="docs/screenshots/add-task.png" alt="Add task" width="280" />
</p>

| Home screen | Add task |
| :---------: | :------: |
| `docs/screenshots/home-mobile.png` | `docs/screenshots/add-task.png` |

---

## Features

- Create, edit, and delete tasks
- Animated completion toggle
- Search, filters (all / active / completed), and sorting
- Swipe right: **Done** and **Delete**
- Drag-and-drop reordering (manual sort mode)
- Local storage via `SharedPreferences`
- Responsive layout: mobile, tablet, desktop, and web
- Cyber UI: gradients, glassmorphism, neon glow

---

## Tech stack

| Category     | Technologies                                                                                                         |
| ------------ | -------------------------------------------------------------------------------------------------------------------- |
| Framework    | [Flutter](https://flutter.dev)                                                                                       |
| State        | [Provider](https://pub.dev/packages/provider)                                                                        |
| Storage      | [shared_preferences](https://pub.dev/packages/shared_preferences)                                                    |
| UI           | [google_fonts](https://pub.dev/packages/google_fonts), [flutter_slidable](https://pub.dev/packages/flutter_slidable) |
| Architecture | Clean Architecture (domain / data / presentation)                                                                    |

---

## Getting started

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.13**
- Dart **≥ 3.1**

### Install

```bash
git clone https://github.com/amantobae/todo-app.git
cd todo-app
flutter pub get
```

### Run

```bash
flutter run
```

### Tests

```bash
flutter analyze
flutter test
```

---

## Project structure

```
lib/
├── core/           # theme, gradients, shared widgets
├── domain/         # entities and repository contracts
├── data/           # models, datasource, repository impl
├── presentation/   # screens, widgets, controller
├── app.dart
└── main.dart
```

---

## License

MIT — see [LICENSE](LICENSE).

---

## Author

**Your Name** · [@amantobae](https://github.com/amantobae)
