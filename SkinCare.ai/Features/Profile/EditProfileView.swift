import SwiftUI

struct EditProfileView: View {
    @StateObject private var userData = UserData.shared
    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var age: String = ""
    @State private var skinType: String = ""
    @State private var goals: [String] = []
    @State private var newGoal = ""
    @State private var showingAddGoal = false
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""

    private let skinTypes = ["Normal", "Dry", "Oily", "Combination", "Sensitive"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image Section
                    VStack(spacing: 16) {
                        Circle()
                            .fill(.pink.opacity(0.2))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.pink)
                            )
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.pink.opacity(0.3), lineWidth: 2)
                        )
                        
                        Button("Change Photo") {
                            // Photo picker functionality would go here
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.pink)
                    }
                    .padding(.top, 20)
                    
                    // Personal Information Card
                    EditCard(title: "Personal Information", icon: "person.circle.fill", color: .blue) {
                        VStack(spacing: 20) {
                            EditField(label: "Display Name", text: $displayName, icon: "person", placeholder: "Enter your name")
                            EditField(label: "Age", text: $age, icon: "calendar", placeholder: "Enter your age", keyboardType: .numberPad)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.blue)
                                        .frame(width: 20)
                                    
                                    Text("Skin Type")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                                
                                Menu {
                                    ForEach(skinTypes, id: \.self) { type in
                                        Button(type) {
                                            skinType = type
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(skinType.isEmpty ? "Select skin type" : skinType)
                                            .foregroundStyle(skinType.isEmpty ? .secondary : .primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.quaternary)
                                    )
                                }
                            }
                        }
                    }
                    
                    // Goals Card
                    EditCard(title: "Skincare Goals", icon: "target", color: .green) {
                        VStack(spacing: 16) {
                            ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 16))
                                    
                                    Text(goal)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Button {
                                        goals.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.red)
                                            .font(.system(size: 16))
                                    }
                                }
                            }
                            
                            Button {
                                showingAddGoal = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 16))
                                    
                                    Text("Add Goal")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.green)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }


                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.pink)
                }
            }
        }
        .onAppear {
            // Load current user data
            displayName = userData.name
            age = userData.age
            skinType = userData.skinType.isEmpty ? "Combination" : userData.skinType
            goals = userData.goals.isEmpty ? [] : userData.goals
        }
        .alert("Add Goal", isPresented: $showingAddGoal) {
            TextField("Enter goal", text: $newGoal)
            Button("Cancel", role: .cancel) {
                newGoal = ""
            }
            Button("Add") {
                if !newGoal.isEmpty {
                    goals.append(newGoal)
                    newGoal = ""
                }
            }
        } message: {
            Text("What skincare goal would you like to add?")
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }

    // MARK: - Helper Methods

    private func saveProfile() {
        // Validate inputs
        if displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationMessage = "Please enter your name"
            showingValidationAlert = true
            return
        }

        if !age.isEmpty {
            guard let ageInt = Int(age), ageInt >= 13 && ageInt <= 100 else {
                validationMessage = "Please enter a valid age between 13 and 100"
                showingValidationAlert = true
                return
            }
        }

        // Save the profile
        userData.updateProfile(
            name: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
            age: age,
            skinType: skinType,
            goals: goals
        )

        // Provide haptic feedback
        let successFeedback = UINotificationFeedbackGenerator()
        successFeedback.notificationOccurred(.success)

        dismiss()
    }
}

struct EditCard<Content: View>: View {
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

struct EditField: View {
    let label: String
    @Binding var text: String
    let icon: String
    var placeholder: String? = nil
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(.blue)
                    .frame(width: 20)

                Text(label)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()
            }

            TextField(placeholder ?? label, text: $text)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.quaternary)
                )
        }
    }
}

#Preview {
    EditProfileView()
}
