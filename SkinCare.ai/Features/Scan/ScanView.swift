import SwiftUI

/// Main view for capturing and analyzing skin photos
/// Provides camera capture, photo selection, and analysis initiation
struct ScanView: View {
    // MARK: - State Objects

    @StateObject private var viewModel: ScanViewModel
    @StateObject private var networkMonitor = NetworkMonitor.shared

    // MARK: - State

    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var isAnimating = false
    @State private var showingNetworkAlert = false

    // MARK: - Initialization

    init(viewModel: ScanViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: Header Section
                VStack(spacing: 12) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 32))
                        .foregroundStyle(.pink.gradient)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text("AI Skin Analysis")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.primary)
                    
                    Text("Capture a photo to get personalized skincare insights")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Camera preview or captured image
                Group {
                    if let image = capturedImage {
                        VStack(spacing: 16) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(.pink.opacity(0.3), lineWidth: 2)
                                )
                                .shadow(color: .pink.opacity(0.2), radius: 16, x: 0, y: 8)
                            
                            Button("Retake Photo") {
                                HapticManager.light()
                                AppLogger.debug("Retaking photo", category: .scan)
                                withAnimation(.spring()) {
                                    capturedImage = nil
                                    viewModel.clearResults()
                                }
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.pink)
                        }
                    } else {
                        Button {
                            showingCamera = true
                        } label: {
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(.pink.opacity(0.1))
                                        .frame(width: 120, height: 120)
                                    
                                    Circle()
                                        .stroke(.pink.opacity(0.3), lineWidth: 2)
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.pink.gradient)
                                }
                                
                                VStack(spacing: 8) {
                                    Text("Tap to Capture")
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    
                                    Text("Position your face in the frame")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 320)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .stroke(.pink.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
                        }
                    }
                }

                // Tips Card
                TipsCard()
                
                // Action Buttons
                if capturedImage == nil {
                    VStack(spacing: 12) {
                        ModernActionButton(
                            title: "Take Photo",
                            icon: "camera.fill",
                            color: .pink,
                            style: .primary
                        ) {
                            showingCamera = true
                        }
                        
                        ModernActionButton(
                            title: "Choose from Library",
                            icon: "photo.fill",
                            color: .blue,
                            style: .secondary
                        ) {
                            showingImagePicker = true
                        }
                    }
                }
                
                if capturedImage != nil {
                    ModernActionButton(
                        title: viewModel.isAnalyzing ? "Analyzing..." : "Analyze Skin",
                        icon: viewModel.isAnalyzing ? nil : "sparkles",
                        color: .pink,
                        style: .primary,
                        isLoading: viewModel.isAnalyzing
                    ) {
                        // Check network connectivity before analysis
                        guard networkMonitor.isConnected else {
                            showingNetworkAlert = true
                            HapticManager.warning()
                            AppLogger.warning("Analysis attempted without network connection", category: .scan)
                            return
                        }

                        HapticManager.medium()
                        AppLogger.info("Starting skin analysis", category: .scan)

                        Task {
                            if let image = capturedImage,
                               let imageData = image.jpegData(compressionQuality: 0.8) {
                                await viewModel.analyze(imageData: imageData)

                                if viewModel.lastResult != nil {
                                    HapticManager.scanComplete()
                                    AppLogger.info("Skin analysis completed successfully", category: .scan)
                                } else if viewModel.errorMessage != nil {
                                    HapticManager.error()
                                    AppLogger.error("Skin analysis failed", category: .scan)
                                }
                            }
                        }
                    }
                    .disabled(viewModel.isAnalyzing)
                }

                if let result = viewModel.lastResult {
                    NavigationLink {
                        ResultsView(result: result)
                    } label: {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("View Results")
                                    .font(.headline.weight(.semibold))
                                
                                Text("See your skin analysis")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                        .foregroundStyle(.primary)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(.green.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: .green.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }

                if let error = viewModel.errorMessage {
                    ErrorView(
                        variant: .banner,
                        title: "Analysis Failed",
                        message: error,
                        actionTitle: "Dismiss"
                    ) {
                        viewModel.clearResults()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Scan")
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 8) }
        .sheet(isPresented: $showingCamera) {
            CameraView(capturedImage: $capturedImage)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $capturedImage, sourceType: .photoLibrary)
        }
        .networkAlert(isPresented: $showingNetworkAlert)
        .onAppear {
            isAnimating = true
            AppLogger.info("ScanView appeared", category: .ui)
        }
        .onChange(of: capturedImage) { newValue in
            if newValue != nil {
                AppLogger.debug("Image captured", category: .scan)
            }
        }
    }
}

// MARK: - Tips Card

/// Displays helpful tips for capturing the best skin scan photos
struct TipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundStyle(.orange.gradient)
                
                Text("Tips for Best Results")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(icon: "sun.max.fill", text: "Use natural lighting when possible")
                TipRow(icon: "eye.slash.fill", text: "Remove glasses and masks")
                TipRow(icon: "face.smiling.fill", text: "Keep a neutral expression")
                TipRow(icon: "camera.macro", text: "Position face 12-18 inches from camera")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.orange.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .orange.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Tip Row

/// Individual tip row with icon and text
struct TipRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.orange)
                .frame(width: 16)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }
}

// MARK: - Modern Action Button

/// Reusable action button with primary and secondary styles
/// Supports loading states and custom icons
struct ModernActionButton: View {
    // MARK: - Properties

    let title: String
    let icon: String?
    let color: Color
    let style: ButtonStyle
    let isLoading: Bool
    let action: () -> Void

    // MARK: - Button Style

    enum ButtonStyle {
        case primary, secondary
    }

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Initialization

    init(title: String, icon: String? = nil, color: Color, style: ButtonStyle, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.title3)
                }
                
                Text(title)
                    .font(.headline.weight(.semibold))
            }
            .foregroundColor(style == .primary ? .white : color)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Group {
                    if style == .primary {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(color)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Material.ultraThinMaterial)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(style == .secondary ? color.opacity(0.3) : .clear, lineWidth: 1)
                )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(color: style == .primary ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
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

// MARK: - Previews

#Preview {
    NavigationStack {
        ScanView(viewModel: ScanViewModel(analyzer: MockAnalyzer()))
    }
}
