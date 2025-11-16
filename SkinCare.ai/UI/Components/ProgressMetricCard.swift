import SwiftUI

// MARK: - Progress Metric Card

/// Compact card displaying a progress metric with icon, value, and change indicator
/// Features interactive press animation and gradient icon styling
struct ProgressMetricCard: View {
    // MARK: - Properties

    let title: String
    let value: String
    let change: String
    let color: Color
    let icon: String

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color.gradient)
                    .frame(width: 32, height: 32)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                
                Text(change)
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
        }
    }
}

// MARK: - Previews

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 12) {
        ProgressMetricCard(
            title: "Scans Completed",
            value: "12",
            change: "+3 this week",
            color: .pink,
            icon: "camera.viewfinder"
        )
        
        ProgressMetricCard(
            title: "Skin Score",
            value: "78%",
            change: "+5% improvement",
            color: .green,
            icon: "chart.line.uptrend.xyaxis"
        )
    }
    .padding()
}
