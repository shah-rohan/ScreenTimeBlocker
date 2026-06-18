import SwiftUI

struct ShortcutsGuideView: View {
    @State private var showCopiedAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Setup Guide")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Use iOS Shortcuts to redirect apps")
                    .foregroundColor(.secondary)
                
                // URL Scheme box
                VStack(spacing: 12) {
                    Text("Your App URL")
                        .font(.headline)
                    
                    HStack {
                        Text("focusblocker://puzzle")
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Button(action: {
                            UIPasteboard.general.string = "focusblocker://puzzle"
                            showCopiedAlert = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCopiedAlert = false
                            }
                        }) {
                            Image(systemName: "doc.on.doc.fill")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    if showCopiedAlert {
                        Text("✓ Copied to clipboard!")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                GuideStep(
                    number: 1,
                    title: "Open Shortcuts App",
                    description: "Open the built-in Shortcuts app on your iPhone"
                )
                
                GuideStep(
                    number: 2,
                    title: "Create Automation",
                    description: "Tap the 'Automation' tab at the bottom, then tap the + button"
                )
                
                GuideStep(
                    number: 3,
                    title: "Choose 'App'",
                    description: "Select 'App' as the trigger type, then choose 'Is Opened'"
                )
                
                GuideStep(
                    number: 4,
                    title: "Select Apps to Block",
                    description: "Choose Instagram, TikTok, Twitter, or any apps you want to add friction to"
                )
                
                GuideStep(
                    number: 5,
                    title: "Add 'Open App' Action",
                    description: "Search for 'Open App' and select Focus Blocker from the list"
                )
                
                GuideStep(
                    number: 6,
                    title: "Disable Ask Before Running",
                    description: "Turn OFF 'Ask Before Running' so it triggers automatically"
                )
                
                GuideStep(
                    number: 7,
                    title: "Test It",
                    description: "Try opening one of your blocked apps. You should see the puzzle!"
                )
            }
            .padding()
        }
        .navigationTitle("Setup")
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
                    .frame(width: 32, height: 32)
                
                Text("\(number)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.caption)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}