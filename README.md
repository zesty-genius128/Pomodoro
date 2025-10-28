# 🍅 Pomodoro Timer

A beautiful and feature-rich Pomodoro timer application built with Flutter. Stay focused and boost your productivity with the Pomodoro Technique!

## ✨ Features

- **⏱️ Customizable Timer Sessions**
  - Focus sessions (default 25 minutes)
  - Short breaks (default 5 minutes)
  - Long breaks (default 15 minutes)
  
- **🎨 Beautiful UI**
  - Smooth animations and transitions
  - Circular progress indicator
  - Light and dark theme support
  - System theme integration

- **📊 Session Tracking**
  - Track completed Pomodoro sessions
  - Automatic cycle management (focus → break → focus)
  - Long break after every 4 sessions

- **⚙️ Flexible Settings**
  - Customize duration for all timer types
  - Adjust long break intervals
  - Persistent settings across sessions

- **🌐 Cross-Platform**
  - Android
  - iOS
  - Web
  - Windows
  - macOS
  - Linux

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.9.0 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/zesty-genius128/Pomodoro.git
cd Pomodoro
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

For specific platforms:
```bash
# Run on web
flutter run -d chrome

# Run on Android
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios

# Run on desktop
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## 📱 Usage

1. **Start a Session**: Press the "Start" button to begin a Pomodoro session
2. **Pause/Resume**: Use the "Pause" button to pause and resume the timer
3. **Reset**: Click "Reset" to restart the current session
4. **Adjust Settings**: Tap the settings icon (⚙️) to customize timer durations
5. **Track Progress**: View your completed sessions at the bottom of the screen

### The Pomodoro Technique

1. Choose a task to work on
2. Set the timer for 25 minutes (one Pomodoro)
3. Work on the task until the timer rings
4. Take a short 5-minute break
5. After 4 Pomodoros, take a longer 15-minute break

## 🛠️ Technologies Used

- **Flutter** - UI framework for building natively compiled applications
- **Dart** - Programming language optimized for building mobile, desktop, server, and web applications
- **Material Design** - Design system for creating beautiful and intuitive user interfaces

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   └── theme/          # Theme and styling
├── features/
│   ├── timer/
│   │   ├── data/       # Timer settings and data models
│   │   └── presentation/  # Timer UI screens
│   └── settings/
│       └── presentation/  # Settings UI screens
├── shared/
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available for personal and educational use.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Inspired by the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) by Francesco Cirillo
- Icons from [Material Design Icons](https://fonts.google.com/icons)

---

Made with ❤️ using Flutter
