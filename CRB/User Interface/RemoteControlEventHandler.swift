import SwiftUI

extension View {
    func handleRemoteControlEvents() -> some View {
        self.background(RemoteControlEventHandler())
    }
}

struct RemoteControlEventHandler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.becomeFirstResponder()
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        
        override var canBecomeFirstResponder: Bool {
            true
        }
        
        override func remoteControlReceived(with event: UIEvent?) {
            guard let event = event else { return }
            
            MusicPlayer.shared.handle(event)
        }
    }
}
