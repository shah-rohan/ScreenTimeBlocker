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
                try await store.service.requestAuthorization()
                await MainActor.run {
                    store.isAuthorized = true
                    isRequesting = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isRequesting = false
                }
            }
        }
    }
    
    func checkAuthStatus() {
        let status = store.service.getAuthorizationStatus()
        errorMessage = "Status: \(status)"
        
        if status.contains("Approved") {
            store.isAuthorized = true
        }
    }
}