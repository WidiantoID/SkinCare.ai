import SwiftUI

extension DateFormatter {
    static let memberSince: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
}

struct ProfileView: View {
    @ObservedObject var session: SessionViewModel
    @StateObject private var userData = UserData.shared
    @State private var isEditing = false
    @State private var skinType = "Combination"
    @State private var goals = ["Reduce acne", "Even skin tone", "Anti-aging"]
    @State private var showingSignOutAlert = false
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with profile image and basic info
                VStack(spacing: 20) {
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(.pink.opacity(0.2))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.pink)
                            )
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.pink.opacity(0.3), lineWidth: 3)
                        )
                        .shadow(color: .pink.opacity(0.2), radius: 12, x: 0, y: 6)
                        
                        // Edit button overlay
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                    impactFeedback.impactOccurred()
                                    isEditing = true
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .frame(width: 28, height: 28)
                                        .background(.pink.gradient, in: Circle())
                                        .shadow(color: .pink.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .frame(width: 120, height: 120)
                    }
                    
                    VStack(spacing: 8) {
                        Text(userData.name.isEmpty ? "Welcome!" : userData.name)
                            .font(.title.weight(.bold))
                            .foregroundStyle(.primary)
                        
                        Text("Member since \(DateFormatter.memberSince.string(from: Date()))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 20)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                
                // Personal Information Card
                ProfileInfoCard(
                    title: "Personal Information",
                    icon: "person.circle.fill",
                    color: .blue
                ) {
                    VStack(spacing: 16) {
                        ProfileInfoRow(label: "Age", value: userData.age.isEmpty ? "Not set" : userData.age, icon: "calendar")
                        ProfileInfoRow(label: "Skin Type", value: skinType, icon: "drop.fill")
                    }
                }
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                
                // Goals Card
                ProfileInfoCard(
                    title: "Skincare Goals",
                    icon: "target",
                    color: .green
                ) {
                    VStack(spacing: 12) {
                        ForEach(goals, id: \.self) { goal in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 16))
                                
                                Text(goal)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 40)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
                
                // Statistics Card
                ProfileInfoCard(
                    title: "Your Progress",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .purple
                ) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatisticItem(title: "Scans", value: "12", color: .pink)
                        StatisticItem(title: "Avg Score", value: "78%", color: .green)
                        StatisticItem(title: "Streak", value: "7 days", color: .orange)
                        StatisticItem(title: "Goals", value: "\(goals.count)", color: .blue)
                    }
                }
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 50)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
                
                // Sign Out Button
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingSignOutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Sign Out")
                            .font(.headline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.red.gradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 8)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 60)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isEditing) {
            EditProfileView(
                displayName: $userData.name,
                age: $userData.age,
                skinType: $skinType,
                goals: $goals
            )
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                Task {
                    await session.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                animateCards = true
            }
        }
    }
}

struct ProfileInfoCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color.gradient)
                
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .frame(width: 20)
            
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }
}

struct StatisticItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.1))
        )
    }
}
#Preview {
    NavigationStack { ProfileView(session: SessionViewModel(auth: MockAuthService())) }
}
