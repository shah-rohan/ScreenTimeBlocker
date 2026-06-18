import SwiftUI
import FamilyControls

struct AuthorizationView: View {
    @EnvironmentObject var store: AppBlockerStore
    @State private var errorMessage: String?
    @State private var isRequesting = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hourglass.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Screen Time Permission Required")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This app needs permission to monitor and block apps for your productivity.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Button(action: requestAuthorization) {
                HStack {
                    if isRequesting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(isRequesting ? "Requesting..." : "Grant Permission")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isRequesting ? Color.gray : Color.blue)
                .cornerRadius(10)
            }
            .disabled(isRequesting)
            .padding(.horizontal)
            
            // Add a test button to check authorization status
            Button(action: checkAuthStatus) {
                Text("Check Authorization Status")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func requestAuthorization() {
        isRequesting = true
        errorMessage = nil
        
        Task {
            do {
                print("🔐 Requesting Family Controls authorization...")
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("✅ Authorization granted!")
                
                await MainActor.run {
                    store.isAuthorized = true
                    isRequesting = false
                }
            } catch {
                print("❌ Authorization failed: \(error)")
                print("Error details: \(error.localizedDescription)")
                
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isRequesting = false
                }
            }
        }
    }
    
    func checkAuthStatus() {
        let status = AuthorizationCenter.shared.authorizationStatus
        print("📊 Current authorization status: \(status)")
        
        switch status {
        case .notDetermined:
            errorMessage = "Status: Not yet requested"
        case .denied:
            errorMessage = "Status: Denied - Try again"
        case .approved:
            errorMessage = "Status: Approved! ✓"
            store.isAuthorized = true
        @unknown default:
            errorMessage = "Status: Unknown"
        }
    }
}