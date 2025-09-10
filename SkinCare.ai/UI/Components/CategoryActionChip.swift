import SwiftUI

struct CategoryActionChip: View {
    let title: String
    let icon: String
    let color: Color
    let count: Int?
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, icon: String, color: Color, count: Int? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.count = count
        self.isSelected = isSelected
        self.action = action
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isSelected ? .white : color)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                
                if let count = count, count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? .white.opacity(0.2) : Color.gray.opacity(0.2))
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? color : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isSelected ? .clear : color.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
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
    HStack(spacing: 8) {
        CategoryActionChip(
            title: "All",
            icon: "circle.grid.3x3.fill",
            color: .blue,
            count: 25,
            isSelected: true
        ) { }
        
        CategoryActionChip(
            title: "Favorites",
            icon: "heart.fill",
            color: .pink,
            count: 3
        ) { }
        
        CategoryActionChip(
            title: "Recent",
            icon: "clock.fill",
            color: .orange,
            count: 5
        ) { }
    }
    .padding()
}
