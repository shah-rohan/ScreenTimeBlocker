import SwiftUI

struct ShortcutsGuideView: View {
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Setup App Blocking")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Use iOS Shortcuts to redirect distracting apps to this puzzle app")
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                // Step 1
                SetupStepView(
                    number: 1,
                    title: "Open Shortcuts App",
                    description: "Open the built-in Shortcuts app on your iPhone"
                ) {
                    Button(action: openShortcutsApp) {
                        Label("Open Shortcuts", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                // Step 2
                SetupStepView(
                    number: 2,
                    title: "Create Automation",
                    description: "Tap the 'Automation' tab, then tap '+' to create a new automation"
                )
                
                // Step 3
                SetupStepView(
                    number: 3,
                    title: "Choose 'App'",
                    description: "Select 'App' as the trigger, then choose 'Is Opened'"
                )
                
                // Step 4
                SetupStepView(
                    number: 4,
                    title: "Select Distracting Apps",
                    description: "Choose apps you want to block (Instagram, TikTok, Twitter, etc.)"
                )
                
                // Step 5
                SetupStepView(
                    number: 5,
                    title: "Add Action: Open App",
                    description: "Search for 'Open App' action and select 'Focus Blocker' (this app)"
                )
                
                // Step 6
                SetupStepView(
                    number: 6,
                    title: "Disable 'Ask Before Running'",
                    description: "Turn OFF 'Ask Before Running' so it happens automatically"
                )
                
                // Visual guide
                VStack(alignment: .leading, spacing: 12) {
                    Text("📱 What Happens:")
                        .font(.headline)
                    
                    FlowStepView(emoji: "📱", text: "You open Instagram")
                    FlowStepView(emoji: "⚡️", text: "Shortcut automatically triggers")
                    FlowStepView(emoji: "🧩", text: "Focus Blocker opens with a puzzle")
                    FlowStepView(emoji: "✅", text: "Complete puzzle to continue")
                    FlowStepView(emoji: "🎯", text: "Return to Instagram (or stay focused!)")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // URL Scheme info
                VStack(alignment: .leading, spacing: 12) {
                    Text("🔗 URL Scheme")
                        .font(.headline)
                    
                    Text("Use this in Shortcuts: focusblocker://puzzle")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: copyURLScheme) {
                        Label("Copy URL Scheme", systemImage: "doc.on.doc")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Video tutorial placeholder
                Button(action: {}) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                        Text("Watch Video Tutorial")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Setup Guide")
    }
    
    func openShortcutsApp() {
        if let url = URL(string: "shortcuts://") {
            UIApplication.shared.open(url)
        }
    }
    
    func copyURLScheme() {
        UIPasteboard.general.string = "focusblocker://puzzle"
    }
}

struct SetupStepView<Content: View>: View {
    let number: Int
    let title: String
    let description: String
    let action: Content?
    
    init(number: Int, title: String, description: String, @ViewBuilder action: () -> Content = { EmptyView() }) {
        self.number = number
        self.title = title
        self.description = description
        self.action = action()
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)
                
                Text("\(number)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                action
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct FlowStepView: View {
    let emoji: String
    let text: String
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.title2)
            Text(text)
            Spacer()
        }
    }
}