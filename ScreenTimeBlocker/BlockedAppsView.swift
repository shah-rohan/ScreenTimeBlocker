import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

struct BlockedAppsView: View {
    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()
    @State private var isBlocking = false
    
    let store = ManagedSettingsStore()
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Block Distracting Apps", isOn: $isBlocking)
                .padding()
                .onChange(of: isBlocking) { newValue in
                    if newValue {
                        applyShield()
                    } else {
                        removeShield()
                    }
                }
            
            Button(action: {
                isPickerPresented = true
            }) {
                Label("Select Apps to Block", systemImage: "app.badge.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !selection.applicationTokens.isEmpty {
                VStack(alignment: .leading) {
                    Text("Apps Selected: \(selection.applicationTokens.count)")
                        .font(.headline)
                    Text("Toggle the switch above to block/unblock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            Spacer()
        }
        .familyActivityPicker(isPresented: $isPickerPresented, selection: $selection)
    }
    
    func applyShield() {
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
    }
    
    func removeShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
}