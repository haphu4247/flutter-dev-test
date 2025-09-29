# Flutter Test Dev

A Flutter application with modern architecture, internationalization support, and comprehensive features including authentication, networking, and theme management.

## Features

- 🌍 **Internationalization**: Support for English and Vietnamese
- 🔐 **Authentication**: Login system with state management
- 🌐 **Network Management**: Connectivity monitoring and error handling
- 🎨 **Theme Support**: Light/Dark theme switching
- 📱 **Cross-platform**: Support for Android, iOS, Web, Windows, macOS, and Linux
- 🏗️ **Modern Architecture**: Clean architecture with Riverpod state management
- 🧭 **Navigation**: GoRouter for declarative routing

## Prerequisites

Before running this project, make sure you have the following installed:

### 1. Flutter SDK
- Install Flutter SDK (version 3.10.0 or higher)
- Add Flutter to your PATH
- Verify installation: `flutter doctor`

### 2. Development Tools

#### For Android Development:
- Android Studio or VS Code
- Android SDK (API level 21 or higher)
- Android Emulator or physical device

#### For iOS Development (macOS only):
- Xcode (latest version)
- iOS Simulator or physical device
- CocoaPods: `sudo gem install cocoapods`

#### For Web Development:
- Chrome browser (recommended)

#### For Desktop Development:
- **Windows**: Visual Studio 2019 or later with C++ development tools
- **macOS**: Xcode Command Line Tools
- **Linux**: `sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev`

## Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd flutter_test_dev
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Localization Files
```bash
flutter gen-l10n
```

### 4. Run the Application

#### For Android:
```bash
flutter run
```
Or specify a device:
```bash
flutter run -d android
```

#### For iOS:
```bash
flutter run -d ios
```

#### For Web:
```bash
flutter run -d chrome
```

```

## Building for Production

### Android APK
```bash
flutter build apk
```

### Android App Bundle (recommended for Play Store)
```bash
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Project Structure

```
lib/
├── base/              # Base classes and utilities
│   └── api_client/    # HTTP client configuration
├── l10n/              # Internationalization files
├── models/            # Data models
├── providers/         # Riverpod state management
├── router/            # Navigation configuration
├── screens/           # UI screens
├── services/          # Business logic services
├── storage/           # Local storage management
├── theme/             # App theming
└── widgets/           # Reusable UI components
```

## Dependencies

- **go_router**: Declarative routing
- **flutter_riverpod**: State management
- **dio**: HTTP client
- **shared_preferences**: Local storage
- **connectivity_plus**: Network connectivity
- **pull_to_refresh**: Pull-to-refresh functionality
- **app_settings**: System settings access

## Troubleshooting

### Common Issues

1. **Flutter Doctor Issues**: Run `flutter doctor` and fix any reported issues
2. **Dependencies**: Ensure all dependencies are installed with `flutter pub get`
3. **Localization**: If you see missing localization errors, run `flutter gen-l10n`
4. **Build Issues**: Try cleaning the project:
   ```bash
   flutter clean
   flutter pub get
   flutter gen-l10n
   ```

### Platform-Specific Issues

#### Android
- Ensure Android SDK is properly installed
- Check that your device/emulator has developer options enabled
- For release builds, ensure you have a valid keystore

#### iOS
- Ensure Xcode is updated to the latest version
- Run `cd ios && pod install` if you encounter CocoaPods issues

## Development

### Adding New Features
1. Create models in `lib/models/`
2. Add services in `lib/services/`
3. Create providers in `lib/providers/`
4. Build screens in `lib/screens/`
5. Update routing in `lib/router/`

### Code Style
This project follows Flutter's official style guide. Run the linter:
```bash
flutter analyze
```

### Testing
Run tests:
```bash
flutter test
```

This project is licensed under the MIT License.
