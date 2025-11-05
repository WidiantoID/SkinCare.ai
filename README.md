# SkinCare.ai - Your Personal Skincare Advisor

## Overview
SkinCare.ai is an intelligent iOS application that analyzes your skin and recommends personalized skincare routines. We utilize advanced computer vision and machine learning to ensure you receive tailored advice for your unique skin needs.

## Features
- **Personalized Recommendations:** Receive skincare routines based on your skin type and concerns
- **AI-Powered Analysis:** Benefit from cutting-edge technology to understand your skin better
- **Progress Tracking:** Monitor your skin health journey over time with detailed analytics
- **Ingredient Database:** Explore and learn about skincare ingredients
- **User-Friendly Interface:** Navigate easily with a clean and modern design
- **Privacy-Focused:** All analysis is done on-device to protect your personal data

## System Requirements
- **Supported Devices:** iOS devices (iPhone and iPad)
- **Operating System:** iOS 15.0 or later
- **Storage Space:** At least 150 MB available
- **Camera:** Required for skin analysis features

## Getting Started

### Installation
1. Clone this repository
2. Open `SkinCare.ai.xcodeproj` in Xcode
3. Build and run the project on your iOS device or simulator

### Configuration
The app uses the Gemini API for advanced AI analysis. You can configure your API key in one of two ways:

1. **Environment Variable** (Recommended):
   ```bash
   export GEMINI_API_KEY="your-api-key-here"
   ```

2. **Direct Configuration**:
   Edit `SkinCare.ai/Core/Config/Secrets.swift` and add your API key

> **Note:** The app includes a mock analyzer that works without an API key for testing purposes.

## How to Use SkinCare.ai

1. **Sign Up:** Create a new account with your name and age
2. **Take a Scan:** Use the app's camera feature to capture your skin's current state
3. **Receive Analysis:** The app will analyze your skin and identify concerns
4. **Explore Recommendations:** Browse through your personalized skincare routine and tips
5. **Track Progress:** Monitor your skin health improvements over time
6. **Learn About Ingredients:** Discover ingredients that work best for your skin type

## Architecture

The app follows a clean, modular architecture:

```
SkinCare.ai/
├── Core/
│   ├── Config/          # Configuration and secrets
│   ├── Models/          # Data models
│   ├── Protocols/       # Protocol definitions
│   ├── Services/        # Business logic services
│   └── Session/         # Session and state management
├── Features/
│   ├── Auth/            # Authentication flows
│   ├── Scan/            # Skin scanning functionality
│   ├── Progress/        # Progress tracking views
│   ├── Ingredients/     # Ingredient database
│   └── Profile/         # User profile management
└── UI/
    ├── Components/      # Reusable UI components
    └── Design/          # Design system and theming
```

## Key Technologies

- **SwiftUI:** Modern declarative UI framework
- **Vision Framework:** Face detection and image analysis
- **Gemini API:** Advanced AI-powered skin analysis
- **Combine:** Reactive programming for state management
- **@StateObject & @EnvironmentObject:** State management

## FAQ

### Q: Is SkinCare.ai free to use?
**A:** Yes, SkinCare.ai is free and open-source.

### Q: Is my data secure?
**A:** Yes! All analysis is performed on-device. Your photos and scan results are stored locally on your device only.

### Q: Can I rely on the AI recommendations?
**A:** Our AI is designed to offer tailored advice based on visual analysis. However, we recommend consulting with a dermatologist for severe skin conditions or medical concerns.

### Q: Do I need an internet connection?
**A:** The app can work offline using the mock analyzer. For full AI-powered analysis, an internet connection is required to access the Gemini API.

## Development

### Building from Source
```bash
# Clone the repository
git clone https://github.com/bestfriendai/SkinCare.ai.git

# Open in Xcode
cd SkinCare.ai
open SkinCare.ai.xcodeproj

# Build and run (⌘R)
```

### Testing
The project includes unit tests and UI tests:
```bash
# Run tests in Xcode with ⌘U
# Or use xcodebuild:
xcodebuild test -scheme SkinCare.ai -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.

## Support

If you need help or have questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review the documentation

## Acknowledgments

- Built with SwiftUI and modern iOS development practices
- Uses Google's Gemini API for AI-powered analysis
- Inspired by the need for accessible, personalized skincare advice

---

Thank you for choosing SkinCare.ai! Enjoy your personalized skincare experience!
