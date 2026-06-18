import SwiftUI

struct ShortcutsGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Setup Guide")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Use iOS Shortcuts to redirect apps")
                    .foregroundColor(.secondary)
                
                GuideStep(
                    number: 1,
                    title: "Open Shortcuts App",
                    description: "Open the built-in Shortcuts app"
                )
                
                GuideStep(
                    number: 2,
                    title: "Create Automation",
                    description: "Tap Automation tab, then + button"
                )
                
                GuideStep(
                    number: 3,
                    title: "Choose 'App'",
                    description: "Select App trigger, choose Is Opened"
                )
                
                GuideStep(
                    number: 4,
                    title: "Select Apps",
                    description: "Choose apps you want to block"
                )
                
                GuideStep(
                    number: 5,
                    title: "Add Open App Action",
                    description: "Search for Open App and select Focus Blocker"
                )
                
                Spacer()
            }
            .padding()
        }
    }
}

struct GuideStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)
                
                Text("\(number)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.caption)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}