# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Data persistence for scan history using UserDefaults
- Data persistence for user goals and progress tracking
- Comprehensive inline documentation for all core services
- Custom error types (GeminiAnalyzerError, CameraServiceError)
- `clearHistory()` method in ScanStore for managing scan data
- Goal persistence in ProgressStore
- MIT License
- Comprehensive .gitignore for iOS development
- Info.plist with proper permissions and app metadata
- Secrets.example.swift template for API key configuration
- CONTRIBUTING.md with detailed contribution guidelines
- CODE_OF_CONDUCT.md following Contributor Covenant v2.1
- SECURITY.md with vulnerability reporting process
- CHANGELOG.md to track project changes

### Changed
- Improved Secrets.swift with secure API key handling
- Removed hardcoded API keys from source control
- Enhanced error handling throughout the application
- Improved GeminiAnalyzer with better error messages and documentation
- Enhanced CameraService with comprehensive documentation
- Improved ScanViewModel with better state management
- Updated ProgressGoal to be Codable for persistence
- Completely rewrote README.md with accurate information and proper structure

### Fixed
- Malformed README.md with incorrect URLs
- Missing persistence layer for scan history
- Missing persistence layer for user goals
- Lack of proper error types and messages
- Insufficient inline documentation

### Security
- API keys now loaded from environment variables or build configuration
- Added .gitignore to prevent accidental commits of sensitive data
- Implemented secure configuration management
- Added security policy and vulnerability reporting guidelines

## [1.0.0] - 2025-01-XX

### Added
- Initial release of SkinCare.ai
- AI-powered skin analysis using Gemini API
- Camera integration for capturing skin photos
- Progress tracking with charts and metrics
- Comprehensive ingredient database with 400+ ingredients
- User profile management
- Onboarding flow
- Results view with detailed analysis
- MockAnalyzer for testing without API key
- Face detection using Vision framework
- Custom UI components and design system
- Dark mode support
- Accessibility features

### Features

#### Skin Analysis
- Real-time skin condition detection
- Confidence scores for each condition
- Personalized ingredient recommendations
- Detailed skin analysis reports
- Support for 13 skin conditions:
  - Acne
  - Redness
  - Dark spots
  - Wrinkles
  - Pigmentation
  - Dryness
  - Oiliness
  - Sensitivity
  - Dullness
  - Dehydration
  - Sun damage
  - Pores
  - Texture

#### Progress Tracking
- Scan history with up to 50 previous scans
- Average skin score calculation
- Daily scan streak tracking
- Progress charts and visualizations
- Goal setting and tracking
- Improvement metrics

#### Ingredients
- Database of 400+ skincare ingredients
- Detailed ingredient information
- Benefits and cautions for each ingredient
- Search and filter functionality
- Favorites system
- Category-based organization

#### UI/UX
- Modern SwiftUI interface
- Smooth animations and transitions
- Haptic feedback
- Material design elements
- Gradient backgrounds
- Responsive layouts
- iPad support

## Version History

### Version Numbering

We use [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

### Maintenance

- **Active Support**: Latest version
- **Security Fixes**: Latest version only
- **Bug Fixes**: Latest version only

## Migration Guides

### Upgrading to Future Versions

Migration guides will be provided here for major version upgrades.

## Links

- [Homepage](https://github.com/bestfriendai/SkinCare.ai)
- [Issue Tracker](https://github.com/bestfriendai/SkinCare.ai/issues)
- [Pull Requests](https://github.com/bestfriendai/SkinCare.ai/pulls)

---

**Note**: This changelog is maintained by the project maintainers and contributors. For detailed commit history, see the Git log.
