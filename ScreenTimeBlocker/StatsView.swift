import SwiftUI

struct StatsView: View {
    @EnvironmentObject var puzzleManager: PuzzleManager
    
    var body: some View {
        List {
            Section(header: Text("Today's Activity")) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(.blue)
                    Text("Puzzles Solved")
                    Spacer()
                    Text("\(puzzleManager.attemptsToday)")
                        .fontWeight(.bold)
                }
                
                if let lastAttempt = puzzleManager.lastAttemptTime {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.green)
                        Text("Last Attempt")
                        Spacer()
                        Text(lastAttempt, style: .relative)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Insights")) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("Average per Day")
                        Text("This creates awareness of your habits")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("Coming Soon")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Statistics")
    }
}