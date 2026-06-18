import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 20) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Focus Blocker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("iOS Shortcuts-based app blocker")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Focus Blocker")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationView {
                ShortcutsGuideView()
            }
            .tabItem {
                Label("Setup", systemImage: "gearshape.fill")
            }
        }
    }
}