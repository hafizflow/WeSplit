import SwiftUI

    // MARK: - Alert Configuration
struct AlertConfiguration {
    var blurStyle: UIBlurEffect.Style = .systemMaterial
    var blurIntensity: CGFloat = 0.5
    var maxWidth: CGFloat = 350
    var horizontalPadding: CGFloat = 40
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 20
    var transition: AnyTransition = .scale.combined(with: .opacity)
    var animation: Animation = .spring()
}

    // MARK: - View Extension
extension View {
    func customAlert<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(CustomAlertModifier(isPresented: isPresented, alertContent: content))
    }
    
        // Chaining modifiers for alert configuration
    func alertBlurStyle(_ style: UIBlurEffect.Style) -> some View {
        environment(\.alertConfiguration.blurStyle, style)
    }
    
    func alertBlurIntensity(_ intensity: CGFloat) -> some View {
        environment(\.alertConfiguration.blurIntensity, intensity)
    }
    
    func alertMaxWidth(_ width: CGFloat) -> some View {
        environment(\.alertConfiguration.maxWidth, width)
    }
    
    func alertHorizontalPadding(_ padding: CGFloat) -> some View {
        environment(\.alertConfiguration.horizontalPadding, padding)
    }
    
    func alertCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.alertConfiguration.cornerRadius, radius)
    }
    
    func alertShadowRadius(_ radius: CGFloat) -> some View {
        environment(\.alertConfiguration.shadowRadius, radius)
    }
    
    func alertTransition(_ transition: AnyTransition) -> some View {
        environment(\.alertConfiguration.transition, transition)
    }
    
    func alertAnimation(_ animation: Animation) -> some View {
        environment(\.alertConfiguration.animation, animation)
    }
}

    // MARK: - Environment Key
private struct AlertConfigurationKey: EnvironmentKey {
    static let defaultValue = AlertConfiguration()
}

extension EnvironmentValues {
    var alertConfiguration: AlertConfiguration {
        get { self[AlertConfigurationKey.self] }
        set { self[AlertConfigurationKey.self] = newValue }
    }
    
    var dismissAlert: () -> Void {
        get { self[DismissAlertKey.self] }
        set { self[DismissAlertKey.self] = newValue }
    }
}

private struct DismissAlertKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

    // MARK: - Alert Modifier
struct CustomAlertModifier<AlertContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var alertContent: () -> AlertContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                CustomAlertOverlay(onCancel: { isPresented = false }) {
                    alertContent()
                }
                .zIndex(999)
            }
        }
    }
}

    // MARK: - Custom Alert Overlay
struct CustomAlertOverlay<Content: View>: View {
    var onCancel: () -> Void
    @ViewBuilder var content: Content
    @State private var isVisible = false
    @State private var blurOpacity: CGFloat = 0
    @Environment(\.alertConfiguration) private var config
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Button {
                    dismissAlert()
                } label: {
                    CustomBlur(style: config.blurStyle, intensity: config.blurIntensity)
                        .ignoresSafeArea()
                        .opacity(blurOpacity)
                }
                .buttonStyle(.plain)
                
                if isVisible {
                    content
                        .frame(maxWidth: min(config.maxWidth, geometry.size.width - (config.horizontalPadding * 2)))
                        .background(.ultraThinMaterial)
                        .cornerRadius(config.cornerRadius)
                        .shadow(radius: config.shadowRadius)
                        .transition(config.transition)
                        .environment(\.dismissAlert, dismissAlert)
                }
            }
        }
        .onAppear {
            withAnimation(config.animation) {
                blurOpacity = 1
                isVisible = true
            }
        }
    }
    
    private func dismissAlert() {
        withAnimation(config.animation) {
            blurOpacity = 0
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onCancel()
        }
    }
}

    // MARK: - Custom Blur
struct CustomBlur: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let intensity: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.alpha = intensity
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.alpha = intensity
    }
}

    // MARK: - Example Usage
struct CustomAlertView: View {
    @State private var showSimpleAlert = false
    @State private var showStyledAlert = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("mainBg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Button("Simple Alert") {
                        showSimpleAlert = true
                    }
                    .buttonStyle(.glass)
                    
                    Button("Styled Alert") {
                        showStyledAlert = true
                    }
                    .buttonStyle(.glass)
                    
                    Button("Success Alert") {
                        showSuccessAlert = true
                    }
                    .buttonStyle(.glass)
                }
            }
            .navigationTitle("Custom Alerts")
            .navigationBarTitleDisplayMode(.inline)
                // Simple alert with default settings
            .customAlert(isPresented: $showSimpleAlert) {
                SimpleAlertContent()
            }
                // Styled alert with custom configuration
            .customAlert(isPresented: $showStyledAlert) {
                StyledAlertContent()
            }
            .alertBlurIntensity(0.8)
            .alertMaxWidth(300)
            .alertCornerRadius(30)
            .alertTransition(.move(edge: .bottom).combined(with: .opacity))
                // Success alert with custom styling
            .customAlert(isPresented: $showSuccessAlert) {
                SuccessAlertContent()
            }
            .alertBlurStyle(.systemUltraThinMaterialDark)
            .alertMaxWidth(320)
            .alertAnimation(.spring(response: 0.6, dampingFraction: 0.7))
        }
    }
}

    // MARK: - Alert Content Views
struct SimpleAlertContent: View {
    @Environment(\.dismissAlert) var dismissAlert
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Hello!")
                .font(.headline)
            
            Text("This is a simple alert with default settings.")
                .multilineTextAlignment(.center)
            
            Button("OK") {
                dismissAlert()
            }
            .buttonStyle(.glassProminent)
        }
        .padding()
    }
}

struct StyledAlertContent: View {
    @Environment(\.dismissAlert) var dismissAlert
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow)
            
            Text("Custom Styled")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This alert has custom blur, width, radius, and transition.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            HStack {
                Button("Cancel") {
                    dismissAlert()
                }
                .buttonStyle(.glass)
                
                Button("Confirm") {
                    dismissAlert()
                }
                .buttonStyle(.glassProminent)
            }
        }
        .padding()
    }
}

struct SuccessAlertContent: View {
    @Environment(\.dismissAlert) var dismissAlert
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("Success!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your action was completed successfully.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button("Done") {
                dismissAlert()
            }
            .buttonStyle(.glassProminent)
        }
        .padding()
    }
}

#Preview {
    CustomAlertView()
}
