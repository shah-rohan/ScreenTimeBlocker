import SwiftUI

struct CooldownView: View {
    let cooldownSeconds: TimeInterval = 30
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hourglass")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Cooldown Active")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("You just solved a puzzle!")
                .foregroundColor(.secondary)
            
            Text("\(Int(timeRemaining))s")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
            
            Text("Next puzzle available in")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: {}) {
                Text("Continue")
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
}