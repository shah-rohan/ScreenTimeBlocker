import SwiftUI
import FamilyControls

@main
struct ScreenTimeBlockerApp: App {
    @StateObject private var store = AppBlockerStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

// Store to manage our blocking state
class AppBlockerStore: ObservableObject {
    @Published var isAuthorized = false
    
    let center = AuthorizationCenter.shared
    
    init() {
        // Check authorization status
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
                await MainActor.run {
                    self.isAuthorized = true
                }
            } catch {
                print("Failed to authorize: \(error)")
            }
        }
    }
}