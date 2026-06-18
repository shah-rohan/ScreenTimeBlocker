import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppBlockerStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            mainView
                .tabItem {
                    Label("Blocker", systemImage: "shield.fill")
                }
                .tag(0)
            
            NavigationView {
                ShortcutsGuideView()
            }
            .tabItem {
                Label("Setup", systemImage: "gearshape.fill")
            }
            .tag(1)
        }
    }
    
    var mainView: some View {
        NavigationView {
            VStack {
                if store.usingMockService {
                    MockWarningBanner()
                }
                
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

struct MockWarningBanner: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Development Mode")
                    .fontWeight(.semibold)
            }
            
            Text("App blocking is simulated. Install via App Store for real functionality.")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}