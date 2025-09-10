import SwiftUI

struct EditProfileView: View {
    @Binding var displayName: String
    @Binding var age: String
    @Binding var skinType: String
    @Binding var goals: [String]
    
    @Environment(\.dismiss) private var dismiss
    @State private var newGoal = ""
    @State private var showingAddGoal = false
    
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
                            EditField(label: "Display Name", text: $displayName, icon: "person")
                            EditField(label: "Age", text: $age, icon: "calendar")
                            
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
                        dismiss()
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.pink)
                }
            }
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
            
            TextField(label, text: $text)
                .textFieldStyle(.plain)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.quaternary)
                )
        }
    }
}

#Preview {
    EditProfileView(
        displayName: .constant("Sarah Johnson"),
        age: .constant("28"),
        skinType: .constant("Combination"),
        goals: .constant(["Reduce acne", "Even skin tone", "Anti-aging"])
    )
}
