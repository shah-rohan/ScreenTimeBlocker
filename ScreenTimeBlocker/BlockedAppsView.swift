import SwiftUI
import FamilyControls

struct BlockedAppsView: View {
    @EnvironmentObject var store: AppBlockerStore
    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()
    @State private var isBlocking = false
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Block Distracting Apps", isOn: $isBlocking)
                .padding()
                .onChange(of: isBlocking) { newValue in
                    if newValue {
                        store.service.blockApps(selection)
                    } else {
                        store.service.unblockApps()
                    }
                }
            
            Button(action: {
                if store.usingMockService {
                    selection = FamilyActivitySelection()
                    print("🔧 [MOCK] App picker would appear here")
                } else {
                    isPickerPresented = true
                }
            }) {
                Label(
                    store.usingMockService ? "Select Apps (Simulated)" : "Select Apps to Block",
                    systemImage: "app.badge.fill"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !selection.applicationTokens.isEmpty || store.usingMockService {
                VStack(alignment: .leading) {
                    Text("Apps Selected: \(selection.applicationTokens.count)")
                        .font(.headline)
                    Text(store.usingMockService ? 
                         "In real app, selected apps would be blocked" :
                         "Toggle the switch above to block/unblock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            Spacer()
        }
        .familyActivityPicker(
            isPresented: $isPickerPresented,
            selection: $selection
        )
    }
}