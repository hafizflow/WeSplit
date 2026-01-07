import SwiftUI

struct RPSGame: View {
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var botMove: String = ""
    @State private var userMove: String = ""
    @State private var winner: String = ""
    @State private var round: Int = 0
    @State private var yourScore: Int = 0
    @State private var showResetAlert: Bool = false
    @State private var value: Double = 1
    @State private var date: Date = Date.now
    
        // Simpler winner logic
    func checkWinner() {
        if userMove == botMove {
            winner = "Draw"
            return
        }
        
            // Check if user wins
        let userWins = (userMove == "Rock" && botMove == "Scissors") ||
        (userMove == "Paper" && botMove == "Rock") ||
        (userMove == "Scissors" && botMove == "Paper")
        
        if userWins {
            winner = "You"
            yourScore += 1
        } else {
            winner = "Bot"
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .purple.opacity(0.5), location: 0.3),
                .init(color: .orange.opacity(0.5), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 600)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("The winner is \(winner)")
                    .font(.largeTitle.bold())
                    .winColor(winner == "You")
                
                Spacer()
                
                VStack(spacing: 30) {
                    ForEach(moves, id: \.self) { move in
                        Button {
                            userMove = move
                            botMove = moves.randomElement()!
                            checkWinner()
                            round += 1
                            
                            if round >= 5 {
                                showResetAlert = true
                            }
                        } label: {
                            Text(move)
                                .padding()
                                .font(.title.weight(.semibold))
                        }
                        .frame(width: 200)
                        .buttonStyle(.glass)
                        .buttonSizing(.flexible)
                    }
                }
                .padding(.vertical, 60)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .roundview(round: round, align: .bottomTrailing)
                .roundview(round: yourScore, align: .bottomLeading, isRound: false)
                
                
                Spacer()
                
                Text("Bot move: \(botMove)")
                    .font(.title2)
                
                Stepper("Stepper \(value.formatted())", value: $value, in: 1...5, step: 2)
                
                DatePicker("DataPicker", selection: $date, in: Date.now..., displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
            }
            .alert("Game Over!", isPresented: $showResetAlert) {
                Button("Play Again") {
                    round = 0
                    yourScore = 0
                    winner = ""
                    botMove = ""
                    userMove = ""
                }
            } message: {
                Text("Final Score: \(yourScore)/5")
            }
            .padding()
        }
    }
}


#Preview {
    RPSGame()
}


struct corner: ViewModifier {
    var round: Int
    var align: Alignment
    var isRound: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: align) {
            content
            
            Text(isRound ? "Round \(round)/5" : "YourScore \(round)/5")
                .padding()
        }
    }
}

extension View {
    func roundview(round: Int, align: Alignment, isRound: Bool = true) -> some View {
        modifier(corner(round: round, align: align, isRound: isRound))
    }
}


extension View {
    func winColor(_ isWin: Bool) -> some View {
        self
            .foregroundStyle(isWin ? .white : .black)
    }
}
