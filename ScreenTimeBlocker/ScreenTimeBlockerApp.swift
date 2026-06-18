import SwiftUI

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

class AppBlockerStore: ObservableObject {
    @Published var isAuthorized = false
    @Published var usingMockService = false
    
    let service: BlockingService
    
    init() {
        self.service = BlockingServiceFactory.create()
        self.usingMockService = !service.isRealImplementation
        
        Task {
            await checkInitialStatus()
        }
    }
    
    @MainActor
    func checkInitialStatus() async {
        let status = service.getAuthorizationStatus()
        print("📱 Initial auth status: \(status)")
        
        if status.contains("Approved") {
            self.isAuthorized = true
        }
    }
}