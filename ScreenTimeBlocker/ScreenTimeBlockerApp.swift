import SwiftUI
import FamilyControls

@main
struct ScreenTimeBlockerApp: App {
    @StateObject private var store = AppBlockerStore()
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                ContentView()
                    .environmentObject(store)
            } else {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    Text("iOS 16.0 or later required")
                        .font(.headline)
                    Text("This app requires iOS 16.0 or later to use Screen Time features.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
        }
    }
}

class AppBlockerStore: ObservableObject {
    @Published var isAuthorized = false
    
    let center = AuthorizationCenter.shared
    
    init() {
        // Check initial authorization status
        Task {
            await checkInitialStatus()
        }
    }
    
    @MainActor
    func checkInitialStatus() async {
        let status = center.authorizationStatus
        print("📱 Initial auth status: \(status)")
        
        if status == .approved {
            self.isAuthorized = true
        }
    }
}