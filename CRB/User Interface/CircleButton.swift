import SwiftUI
import SwiftUIVisualEffects

struct CircleButton<Icon: View>: View {
    let action: () -> Void
    @ViewBuilder let icon: Icon
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: self.action) {
                ZStack {
                    BlurEffect()
                        .blurEffectStyle(.systemUltraThinMaterial)
                        .clipShape(Circle())
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    self.icon
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                }
                .animation(nil)
                .contentShape(Circle())
            }
        }
    }
}
