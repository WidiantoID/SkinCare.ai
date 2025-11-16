import SwiftUI

// MARK: - Recent Scan Row

/// Row displaying a recent scan with date, score, and primary concern
/// Features color-coded score display and interactive press feedback
struct RecentScanRow: View {
    // MARK: - Properties

    let date: Date
    let score: Int
    let primaryConcern: String

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Computed Properties

    private var scoreColor: Color {
        switch score {
        case 80...100: return .green
        case 60...79: return .orange
        default: return .red
        }
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 16) {
            // Date circle
            VStack(spacing: 2) {
                Text(DateFormatter.dayFormatter.string(from: date))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(DateFormatter.monthFormatter.string(from: date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Skin Analysis")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text("\(score)%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(scoreColor)
                }
                
                Text("Primary concern: \(primaryConcern)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
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

// MARK: - Date Formatter Extensions

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
}

// MARK: - Previews

#Preview {
    VStack(spacing: 12) {
        RecentScanRow(
            date: Date(),
            score: 82,
            primaryConcern: "Acne"
        )
        
        RecentScanRow(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            score: 75,
            primaryConcern: "Redness"
        )
        
        RecentScanRow(
            date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
            score: 68,
            primaryConcern: "Dryness"
        )
    }
    .padding()
}
