import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home tab
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            // Setup guide tab
            NavigationView {
                ShortcutsGuideView()
            }
            .tabItem {
                Label("Setup", systemImage: "gearshape.fill")
            }
            .tag(1)
            
            // Stats tab
            NavigationView {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            .tag(2)
        }
        .fullScreenCover(isPresented: $appState.showPuzzle) {
            PuzzleView()
                .environmentObject(appState)
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Focus Blocker")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Block distracting apps with puzzles")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Quick stats
            HStack(spacing: 40) {
                StatBox(
                    value: "\(appState.attemptsToday)",
                    label: "Distractions",
                    color: .orange
                )
                
                StatBox(
                    value: "\(appState.puzzlesSolvedToday)",
                    label: "Solved",
                    color: .green
                )
            }
            .padding()
            
            // Test button
            VStack(spacing: 12) {
                Text("Test the Puzzle")
                    .font(.headline)
                
                Button(action: {
                    appState.showPuzzle = true
                    appState.recordAttempt()
                }) {
                    Label("Try a Puzzle", systemImage: "brain.head.profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            Spacer()
            
            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                Text("How it works:")
                    .font(.headline)
                
                HStack(alignment: .top) {
                    Text("1.")
                    Text("Set up iOS Shortcuts for each distracting app")
                }
                
                HStack(alignment: .top) {
                    Text("2.")
                    Text("When you open those apps, you'll get a puzzle")
                }
                
                HStack(alignment: .top) {
                    Text("3.")
                    Text("Solve the puzzle to continue, or give up")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Focus Blocker")
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}