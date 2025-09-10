import SwiftUI

struct ModernConcernCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    let action: (() -> Void)?
    
    @State private var isPressed = false
    
    init(title: String, count: Int, icon: String, color: Color, action: (() -> Void)? = nil) {
        self.title = title
        self.count = count
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color.gradient)
                    .frame(width: 32, height: 32)
                
                Spacer()
                
                Text("\(count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.1))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text("ingredients")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .shadow(color: color.opacity(0.15), radius: 12, x: 0, y: 6)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action?()
        }
    }
}

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 12) {
        ModernConcernCard(
            title: "Acne",
            count: 12,
            icon: "face.dashed",
            color: .red
        )
        
        ModernConcernCard(
            title: "Dark Spots",
            count: 8,
            icon: "sun.min.fill",
            color: .orange
        )
        
        ModernConcernCard(
            title: "Wrinkles",
            count: 15,
            icon: "waveform.path",
            color: .purple
        )
        
        ModernConcernCard(
            title: "Sensitivity",
            count: 6,
            icon: "heart.text.square",
            color: .mint
        )
    }
    .padding()
}
