import SwiftUI

@main
struct ScreenTimeBlockerApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
    
    func handleURL(_ url: URL) {
        print("📱 App opened with URL: \(url)")
        
        // Handle: focusblocker://puzzle
        if url.scheme == "focusblocker" {
            if url.host == "puzzle" {
                // Only show puzzle if enough time has passed
                if appState.shouldShowPuzzle() {
                    appState.showPuzzle = true
                    appState.recordAttempt()
                } else {
                    print("⏭️ Skipping puzzle - cooldown active")
                }
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var showPuzzle = false
    @Published var attemptsToday = 0
    @Published var puzzlesSolvedToday = 0
    @Published var cooldownSeconds: TimeInterval {
        didSet {
            UserDefaults.standard.set(cooldownSeconds, forKey: "cooldownSeconds")
        }
    }
    
    var lastPuzzleTime: Date? {
        UserDefaults.standard.object(forKey: "lastPuzzleTime") as? Date
    }
    
    init() {
        // Load cooldown setting (default 30 seconds)
        self.cooldownSeconds = UserDefaults.standard.double(forKey: "cooldownSeconds")
        if cooldownSeconds == 0 {
            cooldownSeconds = 30
        }
        
        loadStats()
    }
    
    func shouldShowPuzzle() -> Bool {
        guard let lastTime = lastPuzzleTime else {
            // First time, always show
            return true
        }
        
        let timeSinceLastPuzzle = Date().timeIntervalSince(lastTime)
        return timeSinceLastPuzzle >= cooldownSeconds
    }
    
    func recordAttempt() {
        attemptsToday += 1
        UserDefaults.standard.set(Date(), forKey: "lastPuzzleTime")
        saveStats()
    }
    
    func recordPuzzleSolved() {
        puzzlesSolvedToday += 1
        saveStats()
    }
    
    func loadStats() {
        let savedDate = UserDefaults.standard.object(forKey: "statsDate") as? Date ?? Date()
        
        // Reset if it's a new day
        if !Calendar.current.isDateInToday(savedDate) {
            attemptsToday = 0
            puzzlesSolvedToday = 0
        } else {
            attemptsToday = UserDefaults.standard.integer(forKey: "attemptsToday")
            puzzlesSolvedToday = UserDefaults.standard.integer(forKey: "puzzlesSolvedToday")
        }
    }
    
    func saveStats() {
        UserDefaults.standard.set(attemptsToday, forKey: "attemptsToday")
        UserDefaults.standard.set(puzzlesSolvedToday, forKey: "puzzlesSolvedToday")
        UserDefaults.standard.set(Date(), forKey: "statsDate")
    }
}