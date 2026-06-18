import SwiftUI
import FamilyControls

struct ContentView: View {
    @EnvironmentObject var store: AppBlockerStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if store.isAuthorized {
                    BlockedAppsView()
                } else {
                    AuthorizationView()
                }
            }
            .navigationTitle("Focus Blocker")
        }
    }
}