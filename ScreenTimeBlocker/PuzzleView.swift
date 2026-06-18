import SwiftUI

struct PuzzleView: View {
    @EnvironmentObject var puzzleManager: PuzzleManager
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPuzzle: Puzzle
    @State private var userAnswer = ""
    @State private var showError = false
    @State private var attempts = 0
    
    init() {
        _currentPuzzle = State(initialValue: Puzzle.random())
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Solve to Continue")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Complete this puzzle to access your app")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Puzzle
            VStack(spacing: 20) {
                Text(currentPuzzle.question)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                
                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(currentPuzzle.keyboardType)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                if showError {
                    Text("Incorrect! Try again.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            
            // Stats
            HStack(spacing: 30) {
                StatView(title: "Attempts Today", value: "\(puzzleManager.attemptsToday)")
                StatView(title: "This Session", value: "\(attempts)")
            }
            
            Spacer()
            
            // Submit button
            Button(action: checkAnswer) {
                Text("Submit Answer")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(userAnswer.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(userAnswer.isEmpty)
            .padding(.horizontal)
            
            // Skip button (with penalty)
            Button(action: skipPuzzle) {
                Text("Skip (Wait 30 seconds)")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }
    
    func checkAnswer() {
        attempts += 1
        
        if currentPuzzle.isCorrect(userAnswer) {
            // Success!
            puzzleManager.completePuzzle()
            
            // Optionally show success message
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        } else {
            showError = true
            userAnswer = ""
            
            // Hide error after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showError = false
            }
        }
    }
    
    func skipPuzzle() {
        // Show 30 second timer before allowing skip
        // Implementation left as exercise
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Puzzle model
struct Puzzle {
    let question: String
    let answer: String
    let keyboardType: UIKeyboardType
    
    func isCorrect(_ userAnswer: String) -> Bool {
        return userAnswer.trimmingCharacters(in: .whitespaces).lowercased() == answer.lowercased()
    }
    
    static func random() -> Puzzle {
        let puzzles = [
            // Math puzzles
            Puzzle(question: "What is 15 + 27?", answer: "42", keyboardType: .numberPad),
            Puzzle(question: "What is 8 × 7?", answer: "56", keyboardType: .numberPad),
            Puzzle(question: "What is 144 ÷ 12?", answer: "12", keyboardType: .numberPad),
            
            // Word puzzles
            Puzzle(question: "Spell 'FOCUS' backwards", answer: "sucof", keyboardType: .default),
            Puzzle(question: "What has keys but no locks?", answer: "keyboard", keyboardType: .default),
            
            // Pattern recognition
            Puzzle(question: "Complete: 2, 4, 8, 16, __", answer: "32", keyboardType: .numberPad),
            Puzzle(question: "Next letter: A, C, E, G, __", answer: "i", keyboardType: .default),
            
            // Trivia
            Puzzle(question: "How many minutes are in an hour?", answer: "60", keyboardType: .numberPad),
            Puzzle(question: "What color is the sky?", answer: "blue", keyboardType: .default),
        ]
        
        return puzzles.randomElement()!
    }
}