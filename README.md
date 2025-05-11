# TackleBox: A Ghibli-Themed To-do Application

**Tacklebox** is a minimal Flutter web application for managing one-off and recurrent tasks, all wrapped in a cozy Studio Ghibli aesthetic. It was built on Flutter via Dart, hosted on Firebase, and automated with GitHub Actions.

---

## Live Demo

https://perfectly-plump-plums-1c47d.web.app

---

## Features

- Add, complete, and delete todos (one-off tasks)
- Gamification of todo completion via fishing animations and collection
- View todo task completion statistics
- Add, track, and delete recurrent tasks
- View recurrent task statistics and analytics via session time-tracking
- Firebase auth and Firestore sync
- GitHub Actions-powered CI/CD pipeline

---

## Tech Stack

- **Flutter Web**
- **Firebase Hosting, Auth, Firestore**
- **Riverpod** for state management
- **GitHub Actions** for deployment

---

## Local Development

Clone the project:

```bash
git clone https://github.com/Flutter-App-Makers/Capstone-Project.git
cd Capstone-Project
```

Install dependencies:

```bash
flutter pub get
```

Run locally:

```bash
flutter run -d chrome
```

Build for web:

```bash
flutter build web
```

---

## Deployment

All commits to `main` trigger an automatic deploy to Firebase Hosting via GitHub Actions.

To deploy manually:

```bash
flutter build web
firebase deploy
```

---

## Testing

To run tests:

```bash
flutter test
```

---

## License

MIT — free to use, modify, and distribute. Attribution appreciated!

---

## Maintained by

The Flutter-App-Makers (Mason, Mikey, Noah, and Sydney)