import SwiftUI
import FamilyControls

@main
struct ScreenTimeBlockerApp: App {
    @StateObject private var store = AppBlockerStore()
    @StateObject private var puzzleManager = PuzzleManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(puzzleManager)
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
    
    func handleURL(_ url: URL) {
        print("📱 Opened with URL: \(url)")
        
        // focusblocker://puzzle
        if url.scheme == "focusblocker" {
            if url.host == "puzzle" {
                puzzleManager.showPuzzle = true
                puzzleManager.recordAttempt()
            }
        }
    }
}

class PuzzleManager: ObservableObject {
    @Published var showPuzzle = false
    @Published var attemptsToday = 0
    @Published var lastAttemptTime: Date?
    
    func recordAttempt() {
        attemptsToday += 1
        lastAttemptTime = Date()
        
        // Save to UserDefaults
        UserDefaults.standard.set(attemptsToday, forKey: "attemptsToday")
        UserDefaults.standard.set(lastAttemptTime, forKey: "lastAttemptTime")
    }
    
    func completePuzzle() {
        showPuzzle = false
    }
}