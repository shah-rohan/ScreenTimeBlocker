import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let cooldownOptions = [10, 30, 60, 120, 300] // 10s, 30s, 1m, 2m, 5m
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cooldown Period")) {
                    Text("How long before showing another puzzle?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Picker("Cooldown", selection: $appState.cooldownSeconds) {
                        Text("10 seconds").tag(TimeInterval(10))
                        Text("30 seconds").tag(TimeInterval(30))
                        Text("1 minute").tag(TimeInterval(60))
                        Text("2 minutes").tag(TimeInterval(120))
                        Text("5 minutes").tag(TimeInterval(300))
                    }
                    .pickerStyle(.inline)
                }
                
                Section {
                    Text("After solving a puzzle, you won't see another one for this duration. This prevents the app from being too annoying.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}