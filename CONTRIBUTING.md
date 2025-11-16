# Contributing to SkinCare.ai

Thank you for your interest in contributing to SkinCare.ai! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SkinCare.ai.git
   cd SkinCare.ai
   ```
3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/bestfriendai/SkinCare.ai.git
   ```

## Development Setup

### Prerequisites

- **Xcode 15.0+** (latest stable version recommended)
- **iOS 15.0+** deployment target
- **Swift 5.9+**
- **Git** for version control

### Building the Project

1. Open `SkinCare.ai.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)

### Configuration

#### API Keys

The app uses the Gemini API for skin analysis. To configure:

1. Copy the example secrets file:
   ```bash
   cp SkinCare.ai/Core/Config/Secrets.example.swift SkinCare.ai/Core/Config/Secrets.swift
   ```

2. Add your Gemini API key using one of these methods:
   - **Environment Variable** (Recommended):
     ```bash
     export GEMINI_API_KEY="your-api-key-here"
     ```
   - **Edit Secrets.swift** and add your key (not recommended for commits)

> **Note:** The app includes a MockAnalyzer for testing without an API key.

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug Fixes**: Fix issues and improve stability
- **New Features**: Add new functionality
- **Documentation**: Improve docs, add examples, fix typos
- **Performance**: Optimize code for better performance
- **Tests**: Add or improve test coverage
- **UI/UX**: Improve the user interface and experience
- **Accessibility**: Make the app more accessible

### Before You Start

1. **Check existing issues** to see if someone is already working on it
2. **Create an issue** for significant changes to discuss the approach
3. **Keep changes focused**: One feature/fix per pull request

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) with these additions:

#### Naming Conventions

```swift
// ✅ Good
final class ScanViewModel: ObservableObject {
    func analyzeSkin(from imageData: Data) async throws -> ScanResult
}

// ❌ Bad
class scanViewModel: ObservableObject {
    func analyze_skin(imageData: Data) async throws -> ScanResult
}
```

#### Documentation

All public APIs must include documentation comments:

```swift
/// Analyzes skin from image data using AI
/// - Parameter imageData: JPEG or PNG image data
/// - Returns: ScanResult with detected conditions
/// - Throws: GeminiAnalyzerError if analysis fails
public func analyzeSkin(from imageData: Data) async throws -> ScanResult
```

#### Code Organization

- Use `// MARK: -` to organize code into logical sections
- Keep files focused on a single responsibility
- Limit files to ~300-400 lines when possible

#### SwiftUI Best Practices

```swift
// ✅ Extract reusable components
struct ActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
        }
    }
}

// ✅ Use proper state management
@StateObject private var viewModel: ScanViewModel
@Published var isAnalyzing: Bool

// ✅ Use @MainActor for UI-related classes
@MainActor
final class ScanViewModel: ObservableObject {
    // ...
}
```

### Architecture

SkinCare.ai follows a clean architecture pattern:

```
Core/
├── Models/          # Data models
├── Services/        # Business logic
├── Protocols/       # Protocol definitions
└── Session/         # State management

Features/
├── Scan/           # Scanning feature
├── Progress/       # Progress tracking
├── Ingredients/    # Ingredient database
└── Profile/        # User profile

UI/
├── Components/     # Reusable UI components
└── Design/         # Design system
```

### Error Handling

Always use proper error handling:

```swift
// ✅ Custom error types
enum MyServiceError: LocalizedError {
    case invalidInput
    case networkFailure(Error)

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Input validation failed"
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// ✅ Proper async/await error handling
func fetchData() async throws -> Data {
    do {
        return try await service.fetch()
    } catch {
        throw MyServiceError.networkFailure(error)
    }
}
```

## Commit Guidelines

### Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

#### Examples

```bash
feat(scan): Add face detection before analysis

Implement Vision framework integration to detect faces
before sending to the analyzer. This improves accuracy
and reduces unnecessary API calls.

Closes #123
```

```bash
fix(camera): Resolve front camera orientation issue

Camera preview was displaying upside down on some
devices. Fixed by setting proper orientation.

Fixes #456
```

## Pull Request Process

### Creating a Pull Request

1. **Update your fork**:
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-new-feature
   ```

3. **Make your changes** following the coding standards

4. **Test your changes thoroughly**

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feature/my-new-feature
   ```

7. **Open a Pull Request** on GitHub

### PR Requirements

Your PR should:

- [ ] Follow the coding standards
- [ ] Include tests for new functionality
- [ ] Update documentation if needed
- [ ] Have a clear, descriptive title
- [ ] Reference any related issues
- [ ] Pass all CI checks

### PR Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe the tests you ran to verify your changes

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
```

## Reporting Bugs

### Before Submitting

1. **Check existing issues** to avoid duplicates
2. **Test on latest version** to ensure it's not already fixed
3. **Gather information** about the bug

### Bug Report Template

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- Device: [e.g. iPhone 15 Pro]
- iOS Version: [e.g. 17.0]
- App Version: [e.g. 1.0.0]

**Additional context**
Any other relevant information.
```

## Suggesting Enhancements

We love feature suggestions! Please provide:

1. **Clear use case**: Why is this feature needed?
2. **Proposed solution**: How should it work?
3. **Alternatives considered**: Other approaches you've thought about
4. **Additional context**: Screenshots, mockups, examples

## Questions?

Feel free to:
- Open an issue for questions
- Start a discussion in GitHub Discussions
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to SkinCare.ai! 🎉
