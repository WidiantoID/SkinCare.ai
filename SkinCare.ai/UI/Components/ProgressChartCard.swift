import SwiftUI

struct ProgressChartCard: View {
    @State private var animateChart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Skin Health Score")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("78%")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.green)
            }
            
            // Mock chart visualization
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.green.gradient)
                        .frame(width: 24, height: CGFloat.random(in: 40...100))
                        .scaleEffect(y: animateChart ? 1.0 : 0.1, anchor: .bottom)
                        .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.1), value: animateChart)
                }
            }
            .frame(height: 100)
            
            HStack {
                Text("Last 7 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Text("+12% improvement")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    ProgressChartCard()
        .padding()
}
