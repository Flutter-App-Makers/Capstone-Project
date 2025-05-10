# 🎣 Tacklebox: A Ghibli-Themed Todo App

**Tacklebox** is a beautiful, minimal Flutter web application for managing todos and recurrent tasks — all wrapped in a cozy Studio Ghibli aesthetic. Built with ❤️, hosted on Firebase, and automated with GitHub Actions.

---

## 🌐 Live Demo

https://perfectly-plump-plums-1c47d.web.app/?flush

---

## ✨ Features

- ✅ Add, complete, and delete todos
- 🔁 Recurrent task scheduling
- 🐟 Animated fish stats for completed tasks
- 🗂️ Category management
- ☁️ Firebase Auth & Firestore sync
- 💾 Local storage with Hive
- 📤 Import/export todos via `.json`
- 🚀 GitHub Actions-powered CI/CD

---

## 📦 Tech Stack

- **Flutter Web**
- **Firebase Hosting, Auth, Firestore**
- **Hive** for local persistence
- **Riverpod** for state management
- **GitHub Actions** for deployment

---

## 🛠 Local Development

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

## 🚀 Deployment

All commits to `main` trigger an automatic deploy to Firebase Hosting via GitHub Actions.

To deploy manually:

```bash
flutter build web
firebase deploy
```

---

## 🧪 Testing

To run tests:

```bash
flutter test
```

---

## 📄 License

MIT — free to use, modify, and distribute. Attribution appreciated!

---

## 🌱 Maintained by

The ✨ Flutter-App-Makers ✨  
(And our loyal assistant Omega 🧠)