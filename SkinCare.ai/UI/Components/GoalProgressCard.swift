import SwiftUI

struct GoalProgressCard: View {
    let title: String
    let progress: Double
    let target: String
    let color: Color
    
    @State private var animateProgress = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(target)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(color)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.gradient)
                        .frame(width: geometry.size.width * (animateProgress ? progress : 0), height: 8)
                        .animation(.easeOut(duration: 1.0).delay(0.3), value: animateProgress)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateProgress = true
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        GoalProgressCard(
            title: "Reduce Acne",
            progress: 0.7,
            target: "Clear skin in 30 days",
            color: .pink
        )
        
        GoalProgressCard(
            title: "Improve Hydration",
            progress: 0.4,
            target: "Better moisture levels",
            color: .blue
        )
        
        GoalProgressCard(
            title: "Even Skin Tone",
            progress: 0.9,
            target: "Reduce dark spots",
            color: .purple
        )
    }
    .padding()
}
