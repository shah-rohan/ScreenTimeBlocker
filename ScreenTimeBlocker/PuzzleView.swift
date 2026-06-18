import SwiftUI

struct PuzzleView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPuzzle: Puzzle
    @State private var userAnswer = ""
    @State private var showError = false
    @State private var attempts = 0
    @State private var startTime = Date()
    
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
            .padding(.top, 40)
            
            // Puzzle card
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
                    .padding(.horizontal)
                
                if showError {
                    Text("❌ Incorrect! Try again.")
                        .foregroundColor(.red)
                        .font(.callout)
                }
            }
            .padding()
            
            // Stats
            HStack(spacing: 40) {
                VStack {
                    Text("\(appState.attemptsToday)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Distractions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(attempts)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Attempts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(Int(Date().timeIntervalSince(startTime)))s")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
            
            // Give up button (with shame)
            Button(action: giveUp) {
                Text("Give Up (Recorded as distraction)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .interactiveDismissDisabled() // Can't swipe away!
    }
    
    func checkAnswer() {
        attempts += 1
        
        if currentPuzzle.isCorrect(userAnswer) {
            // Success!
            appState.recordPuzzleSolved()
            appState.showPuzzle = false
            
            // Small delay before dismissing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        } else {
            showError = true
            userAnswer = ""
            
            // Shake effect could go here
            
            // Hide error after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showError = false
            }
        }
    }
    
    func giveUp() {
        appState.showPuzzle = false
        dismiss()
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
            // Easy math
            Puzzle(question: "What is 7 + 8?", answer: "15", keyboardType: .numberPad),
            Puzzle(question: "What is 12 + 15?", answer: "27", keyboardType: .numberPad),
            Puzzle(question: "What is 9 × 6?", answer: "54", keyboardType: .numberPad),
            Puzzle(question: "What is 20 ÷ 4?", answer: "5", keyboardType: .numberPad),
            
            // Medium math
            Puzzle(question: "What is 13 × 7?", answer: "91", keyboardType: .numberPad),
            Puzzle(question: "What is 144 ÷ 12?", answer: "12", keyboardType: .numberPad),
            Puzzle(question: "What is 25 + 37?", answer: "62", keyboardType: .numberPad),
            
            // Word puzzles
            Puzzle(question: "Spell 'FOCUS' backwards", answer: "sucof", keyboardType: .default),
            Puzzle(question: "Type the word: PRODUCTIVE", answer: "productive", keyboardType: .default),
            Puzzle(question: "What rhymes with 'best'? (hint: not worst)", answer: "rest", keyboardType: .default),
            
            // Patterns
            Puzzle(question: "Next number: 2, 4, 8, 16, __", answer: "32", keyboardType: .numberPad),
            Puzzle(question: "Next number: 5, 10, 15, 20, __", answer: "25", keyboardType: .numberPad),
            Puzzle(question: "Complete: 1, 1, 2, 3, 5, 8, __", answer: "13", keyboardType: .numberPad),
            
            // Trivia
            Puzzle(question: "Minutes in an hour?", answer: "60", keyboardType: .numberPad),
            Puzzle(question: "Days in a week?", answer: "7", keyboardType: .numberPad),
            Puzzle(question: "Months in a year?", answer: "12", keyboardType: .numberPad),
        ]
        
        return puzzles.randomElement()!
    }
}