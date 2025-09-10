import SwiftUI

struct OnboardingView: View {
    @ObservedObject var session: SessionViewModel
    @StateObject private var userData = UserData.shared
    @State private var userName = ""
    @State private var userAge = ""
    @State private var showUserInput = false
    @State private var currentStep: OnboardingStep = .name
    @State private var isAnimating = false
    
    enum OnboardingStep {
        case name, age
    }
    
    private func isValidAge(_ ageString: String) -> Bool {
        guard let age = Int(ageString) else { return false }
        return age >= 13 && age <= 100
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 64))
                    .foregroundStyle(.pink.gradient)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                    .accessibilityHidden(true)
                
                if showUserInput {
                    VStack(spacing: 16) {
                        if currentStep == .name {
                            Text("What's your name?")
                                .font(.title.weight(.bold))
                                .multilineTextAlignment(.center)
                            
                            Text("Let's personalize your skincare journey")
                                .font(.title3)
                                .foregroundStyle(Theme.subtleText)
                                .multilineTextAlignment(.center)
                            
                            VStack(spacing: 12) {
                                TextField("Enter your name", text: $userName)
                                    .textFieldStyle(.plain)
                                    .font(.title2)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .stroke(.pink.opacity(0.3), lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.center)
                                
                                if !userName.isEmpty {
                                    Text("Hello, \(userName)! 👋")
                                        .font(.headline)
                                        .foregroundStyle(.pink)
                                        .transition(.opacity.combined(with: .scale))
                                }
                            }
                        } else {
                            Text("How old are you?")
                                .font(.title.weight(.bold))
                                .multilineTextAlignment(.center)
                            
                            Text("This helps us provide better recommendations")
                                .font(.title3)
                                .foregroundStyle(Theme.subtleText)
                                .multilineTextAlignment(.center)
                            
                            VStack(spacing: 12) {
                                TextField("Enter your age", text: $userAge)
                                    .textFieldStyle(.plain)
                                    .font(.title2)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onChange(of: userAge) { newValue in
                                        userData.age = newValue
                                    }
                                
                                if !userAge.isEmpty {
                                    if isValidAge(userAge) {
                                        Text("Perfect! ✨")
                                            .font(.headline)
                                            .foregroundStyle(.green)
                                            .transition(.opacity.combined(with: .scale))
                                    } else {
                                        Text("Please enter a valid age (13-100)")
                                            .font(.subheadline)
                                            .foregroundStyle(.red)
                                            .transition(.opacity.combined(with: .scale))
                                    }
                                }
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    VStack(spacing: 12) {
                        Text("Welcome to SkinCareAI")
                            .font(Theme.Typography.largeTitle)
                            .multilineTextAlignment(.center)
                        Text("Personalized skincare insights, powered by AI. Scan your face, track your skin health, and discover ingredients that work for you—all on-device and private.")
                            .font(.title3)
                            .foregroundStyle(Theme.subtleText)
                            .multilineTextAlignment(.center)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal)
            .onAppear {
                isAnimating = true
            }
            if !showUserInput {
                VStack(alignment: .leading, spacing: 20) {
                    FeatureRow(
                        icon: "camera.viewfinder",
                        color: .pink,
                        title: "Scan your skin",
                        description: "Get instant analysis and recommendations."
                    )
                    FeatureRow(
                        icon: "list.bullet",
                        color: .mint,
                        title: "Explore ingredients",
                        description: "Learn about what works for your skin."
                    )
                    FeatureRow(
                        icon: "chart.line.uptrend.xyaxis",
                        color: .orange,
                        title: "Track your progress",
                        description: "See improvements over time."
                    )
                    FeatureRow(
                        icon: "lock.shield",
                        color: .teal,
                        title: "Private & secure",
                        description: "All analysis is done on your device."
                    )
                }
                .padding(.horizontal)
                .transition(.opacity.combined(with: .move(edge: .leading)))
            }
            Spacer()
            
            VStack(spacing: 16) {
                if showUserInput {
                    if currentStep == .name {
                        Button(action: {
                            if !userName.isEmpty {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    currentStep = .age
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right")
                                    .font(.title3)
                                Text("Next")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(userName.isEmpty ? Color.gray : Color.pink)
                            )
                            .shadow(color: userName.isEmpty ? .clear : .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(userName.isEmpty)
                        .animation(.easeInOut(duration: 0.2), value: userName.isEmpty)
                    } else {
                        Button(action: {
                            if !userAge.isEmpty && isValidAge(userAge) {
                                userData.updateUserInfo(name: userName, age: userAge)
                                Task {
                                    await session.signIn(with: .email)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .font(.title3)
                                Text("Start Scanning")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill((userAge.isEmpty || !isValidAge(userAge)) ? Color.gray : Color.green)
                            )
                            .shadow(color: (userAge.isEmpty || !isValidAge(userAge)) ? .clear : .green.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(userAge.isEmpty || !isValidAge(userAge))
                        .animation(.easeInOut(duration: 0.2), value: userAge.isEmpty)
                    }
                } else {
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showUserInput = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .font(.title3)
                            Text("Get Started")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.pink)
                        )
                        .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                
                if showUserInput {
                    Button(currentStep == .name ? "Back" : "Previous") {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            if currentStep == .age {
                                currentStep = .name
                            } else {
                                showUserInput = false
                                userName = ""
                                userAge = ""
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Text(showUserInput ? 
                 (currentStep == .name ? "Enter your name to personalize your experience." : "Your age helps us provide better recommendations.") : 
                 "Tap to start your skincare journey with AI-powered analysis.")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color.gradient)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView(session: SessionViewModel(auth: MockAuthService()))
    }
}


