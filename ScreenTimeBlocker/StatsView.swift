import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    
    var successRate: Int {
        guard appState.attemptsToday > 0 else { return 0 }
        return Int((Double(appState.puzzlesSolvedToday) / Double(appState.attemptsToday)) * 100)
    }
    
    var body: some View {
        List {
            Section(header: Text("Today's Activity")) {
                StatRow(
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .orange,
                    title: "Distraction Attempts",
                    value: "\(appState.attemptsToday)"
                )
                
                StatRow(
                    icon: "checkmark.circle.fill",
                    iconColor: .green,
                    title: "Puzzles Solved",
                    value: "\(appState.puzzlesSolvedToday)"
                )
                
                StatRow(
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: .blue,
                    title: "Success Rate",
                    value: "\(successRate)%"
                )
            }
            
            Section(header: Text("Insights")) {
                if appState.attemptsToday == 0 {
                    Text("No distractions yet today! 🎉")
                        .foregroundColor(.green)
                } else if appState.attemptsToday < 5 {
                    Text("You're doing well! Keep it up.")
                        .foregroundColor(.green)
                } else if appState.attemptsToday < 10 {
                    Text("Quite a few distractions today. Stay focused!")
                        .foregroundColor(.orange)
                } else {
                    Text("High distraction count. Consider adjusting your environment.")
                        .foregroundColor(.red)
                }
            }
            
            Section(header: Text("Tips")) {
                TipRow(tip: "The puzzle creates friction to break automatic app opening")
                TipRow(tip: "Each time you solve a puzzle, you're making a conscious choice")
                TipRow(tip: "Try to reduce your distraction attempts each day")
            }
        }
        .navigationTitle("Statistics")
    }
}

struct StatRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
}

struct TipRow: View {
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.caption)
            
            Text(tip)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}