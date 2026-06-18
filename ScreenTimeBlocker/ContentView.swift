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
    @State private var showingSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                Text("Focus Blocker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Block distracting apps with puzzles")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Cooldown status
                if let lastTime = appState.lastPuzzleTime {
                    let timeSince = Date().timeIntervalSince(lastTime)
                    let remaining = max(0, appState.cooldownSeconds - timeSince)
                    
                    if remaining > 0 {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("Cooldown: \(Int(remaining))s remaining")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
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
                
                // Settings button
                Button(action: { showingSettings = true }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Cooldown: \(Int(appState.cooldownSeconds))s")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
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
                .padding(.horizontal)
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("How it works:")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 8) {
                        Text("1.")
                        Text("Set up iOS Shortcuts for each distracting app")
                    }
                    
                    HStack(alignment: .top, spacing: 8) {
                        Text("2.")
                        Text("When you open those apps, you'll get a puzzle")
                    }
                    
                    HStack(alignment: .top, spacing: 8) {
                        Text("3.")
                        Text("After solving, you get a \(Int(appState.cooldownSeconds))s break")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Focus Blocker")
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(appState)
        }
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