# WhatsApp Web - iOS Utility App

A comprehensive iOS application that provides seamless access to **WhatsApp Web** alongside a powerful suite of text utility and productivity tools. Designed for power users, it enhances the social messaging experience with advanced text manipulation, QR generation, and creative captions.

---

## �� Key Features

### �� WhatsApp Web Integration
Access your WhatsApp messages directly on your iOS device via a dedicated, optimized web interface. Features include:
- Desktop-class WhatsApp Web experience.
- Fast loading with optimized user-agents.
- Simple, intuitive navigation.

### �� Productivity & Text Tools
A versatile toolkit for enhancing your communication:
- **QR Generator**: Create custom QR codes and manage your scan history.
- **Text Repeater**: Instantly duplicate text for emphasis or creative use.
- **Text to Emoji**: Transform plain text into vibrant emoji-based designs.
- **Random Generator**: Generate random text and data on the fly.
- **Text to Alphabet**: Stylize your messages with unique font styles.
- **Caption Collection**: Browse a curated library of creative captions for social media posts.

### �� Premium Experience
- **Ad-Free Usage**: Enjoy an uninterrupted experience by removing all advertisements.
- **Exclusive Content**: Access premium tools and special features.
- **Gift Promotions**: Rewards and special offers for active users.

---

## �� Code Structure & Architecture

The project is built using the **MVC (Model-View-Controller)** architectural pattern, ensuring a clean separation of concerns and maintainability.

### Directory Breakdown
- **`Controllers/`**: The heart of the app logic, containing view controllers organized by feature areas (Main, ToolVC, WebVC, PremiumVC).
- **`Storyboard/`**: Defines the application's UI flow and layout using Interface Builder.
- **`CoreData/`**: Manages local data persistence for features like QR history and saved entities.
- **`CoustomView/`**: Houses reusable UI components and custom view implementations.
- **`Ads/`**: Centralized logic for Google Mobile Ads (AdMob) integration, including native ad handling.
- **`Extension/`**: Helpful Swift extensions for `UIKit` and standard types to streamline development.
- **`Resources/`**: Contains asset catalogs, custom fonts, and Lottie animation files.
- **`Library/`**: Includes specialized utility classes and third-party helpers.

---

## �� Tech Stack

- **Language**: Swift
- **UI Framework**: UIKit (Storyboards & Auto Layout)
- **Dependency Manager**: CocoaPods
- **Persistence**: CoreData
- **External Libraries**:
  - `IQKeyboardManager`: Seamless keyboard interaction.
  - `lottie-ios`: High-quality vector animations.
  - `Google-Mobile-Ads-SDK`: Industry-standard monetization.
  - `ProgressHUD`: User-friendly loading indicators.
  - `SkeletonView`: Smooth loading state transitions.

---

## ⚙️ Requirements

- **iOS Version**: 13.0 or higher
- **Xcode**: 14.0+ recommended
- **Dependencies**: Install via `pod install`

---
