# Kogyo iOS App

<div align="center">
  <img src="https://www.kogyo.co/images/main-logo.svg" alt="Kogyo Logo" width="200"/>
  
  ### Any task, a tap away.
  
  [![Website](https://img.shields.io/badge/Website-kogyo.co-blue)](https://www.kogyo.co/)
  [![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey)]()
  [![Swift](https://img.shields.io/badge/Swift-5.0+-orange)]()
</div>

## 📖 About Kogyo

Kogyo is a revolutionary task marketplace platform that connects customers with skilled helpers for any kind of task. Unlike traditional platforms like TaskRabbit or Thumbtack, Kogyo features a unique **pay-by-job system** where customers set task prices (with AI suggestions), and helpers can choose from local task offers that match their skills and preferences.

### Why Kogyo is Different

- **Customer-Set Pricing**: Customers set their own task prices with AI-powered suggestions for fair market rates
- **Helper Choice**: Helpers choose tasks that work for them, rather than competing in a bidding war
- **Fair Pricing**: Ensures fair compensation for helpers while keeping costs reasonable for customers
- **Qualified Workers**: All helpers are verified and qualified, eliminating the need for customers to pay premium rates just for quality
- **Southeast Asia Focus**: Initially launching in Thailand with plans to expand throughout Southeast Asia

## 🎯 Target Market

Kogyo will initially launch in **Southeast Asia**, starting with Thailand before expanding throughout the region. While our initial focus is on SEA, we plan to take Kogyo worldwide as it addresses a universal problem that people face everywhere.

## ✨ Key Features

### For Customers

- 🔍 **Easy Task Creation**: Create tasks with detailed descriptions, photos, and videos
- 💰 **Flexible Pricing**: Set your own price with AI-powered suggestions
- 📍 **Location-Based**: Find helpers near you using integrated mapping
- 📷 **Media Support**: Attach photos and videos to show exactly what you need
- 💬 **In-App Chat**: Communicate directly with helpers
- ⏱️ **Task Scheduling**: Schedule tasks for specific dates and times
- ✅ **Task Management**: Track ongoing and completed tasks
- 🔔 **Real-Time Updates**: Get notified when helpers accept your tasks

### For Helpers

- 📋 **Task Browsing**: Browse available tasks in your area
- 🎯 **Selective Acceptance**: Choose tasks that match your skills and schedule
- 💵 **Transparent Pricing**: See task prices upfront before accepting
- 📱 **Profile Management**: Build your reputation with completed tasks
- 🗺️ **Location Services**: View tasks on a map to plan your route
- 📸 **Completion Verification**: Upload completion photos for customer approval

## 🏗️ Architecture

### Project Structure

```
Kogyo/
├── Authentication/           # Complete authentication system
│   ├── Auth Models/         # User, Login, and Register models
│   ├── Auth Objects/        # AuthService, Validator
│   └── Authentication Controllers/  # Login, Register, ForgotPassword
├── Customer Side/           # Customer-facing features
│   ├── Controllers/         # Task creation, home, settings, map
│   ├── Models/             # Helper models and settings
│   └── Views/              # Custom UI components
├── Helper Side/            # Helper-facing features
│   ├── Controllers/        # Helper-specific screens
│   └── Views/              # Helper UI components
├── Data/                   # Data management layer
│   ├── FirestoreHandler.swift  # Firebase database operations
│   ├── DataManager.swift   # Centralized data management
│   ├── TaskClass.swift     # Task data model
│   └── Enums.swift         # App-wide enumerations
├── Global Objects/         # Shared utilities
│   ├── AlertManager.swift  # Alert handling
│   ├── Constants.swift     # App constants
│   ├── Extensions.swift    # Swift extensions
│   └── Chat/              # Chat functionality
└── Shared Controllers & Views/  # Reusable components
    └── Task Info Views/    # Task detail screens
```

### Tech Stack

- **Language**: Swift 5.0+
- **UI Framework**: UIKit
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage (for media)
- **Architecture Pattern**: MVC (Model-View-Controller)
- **Location Services**: CoreLocation & MapKit
- **Media Handling**: AVFoundation

## 🚀 Getting Started

### Prerequisites

- macOS 12.0 or later
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- CocoaPods or Swift Package Manager
- Firebase account and project setup

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/GabrielCastilloH/kogyo-swift.git
   cd kogyo-swift
   ```

2. **Install dependencies**

   ```bash
   # If using CocoaPods
   pod install

   # If using SPM, dependencies will be resolved automatically in Xcode
   ```

3. **Configure Firebase**

   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `GoogleService-Info.plist`
   - Add it to the `Kogyo` folder in Xcode
   - Enable Authentication (Email/Password)
   - Create a Firestore database
   - Set up Firebase Storage for media files

4. **Open the project**

   ```bash
   # If using CocoaPods
   open Kogyo.xcworkspace

   # Otherwise
   open Kogyo.xcodeproj
   ```

5. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 🔐 Authentication

The app includes a complete authentication system:

- **User Registration**: Email/password registration with validation
- **Login**: Secure authentication with Firebase Auth
- **Password Recovery**: Forgot password functionality
- **User Types**: Separate flows for customers and helpers
- **Session Management**: Persistent login sessions

## 💾 Database Structure

### Firestore Collections

```
users/
  - {userId}/
    - firstName: String
    - lastName: String
    - email: String
    - isHelper: Boolean
    - profileImageURL: String?

tasks/
  - {taskId}/
    - userUID: String
    - kind: String
    - description: String
    - dateTime: Timestamp
    - expectedHours: Number
    - location: GeoPoint
    - payment: Number
    - helperUID: String?
    - completionStatus: String
    - mediaURLs: Array<String>
    - equipmentNeeded: Array<String>

helpers/
  - {helperId}/
    - rating: Number
    - completedTasks: Number
    - skills: Array<String>
```

## 🤝 Contributing

This is a proprietary project. For collaboration opportunities, please contact the team through the [Kogyo website](https://www.kogyo.co/#contact-us-section).

## 📱 App Features in Detail

### Task Creation Flow

1. Customer creates a task with description and requirements
2. Sets preferred date/time and expected duration
3. Adds location using map interface
4. Uploads relevant photos or videos
5. Sets task price or uses AI-suggested pricing
6. Task becomes available to nearby helpers

### Task Acceptance Flow

1. Helper browses available tasks in their area
2. Views task details including price, location, and requirements
3. Accepts task if it matches their availability and skills
4. Customer receives notification of acceptance
5. Helper and customer can communicate via in-app chat
6. Helper completes task and uploads completion photos
7. Customer verifies completion and releases payment

## 🔮 Future Development

- AI-powered price suggestions
- In-app payment processing
- Helper rating and review system
- Advanced task filtering and search
- Push notifications
- Multi-language support for SEA market
- Helper verification and background checks
- Insurance and dispute resolution

## 📄 License

This project is proprietary and confidential. All rights reserved.

## 👥 Team

Created by **Gabriel Castillo** & **Coluto**

## 🌐 Links

- **Website**: [kogyo.co](https://www.kogyo.co/)
- **GitHub**: [GabrielCastilloH/kogyo-swift](https://github.com/GabrielCastilloH/kogyo-swift)

## 📞 Contact

Have questions or want to get involved? Visit our [contact page](https://www.kogyo.co/#contact-us-section).

---

<div align="center">
  Made with ❤️ by the Kogyo Team
  
  © 2024 Kogyo. All rights reserved.
</div>
