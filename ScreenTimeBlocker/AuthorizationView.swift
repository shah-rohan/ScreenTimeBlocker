import SwiftUI
import FamilyControls

struct AuthorizationView: View {
    @EnvironmentObject var store: AppBlockerStore
    
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
            
            Button(action: requestAuthorization) {
                Text("Grant Permission")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                await MainActor.run {
                    store.isAuthorized = true
                }
            } catch {
                print("Failed to authorize: \(error)")
            }
        }
    }
}