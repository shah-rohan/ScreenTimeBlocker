import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppBlockerStore
    @EnvironmentObject var puzzleManager: PuzzleManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main view
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
            .tabItem {
                Label("Blocker", systemImage: "shield.fill")
            }
            .tag(0)
            
            // Setup guide
            NavigationView {
                ShortcutsGuideView()
            }
            .tabItem {
                Label("Setup", systemImage: "gearshape.fill")
            }
            .tag(1)
            
            // Stats
            NavigationView {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            .tag(2)
        }
        .fullScreenCover(isPresented: $puzzleManager.showPuzzle) {
            PuzzleView()
                .environmentObject(puzzleManager)
                .interactiveDismissDisabled() // Prevent swiping away
        }
    }
}