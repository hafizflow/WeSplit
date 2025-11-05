import SwiftUI

struct RPSGame: View {
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var botMove: String = ""
    @State private var userMove: String = ""
    @State private var winner: String = ""
    @State private var round: Int = 0
    @State private var yourScore: Int = 0
    @State private var showResetAlert: Bool = false
    
        // Simpler winner logic
    func checkWinner() {
            // Draw case
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
            
            VStack {
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
                
                Spacer()
            }
            .alert("Game Over!", isPresented: $showResetAlert) {
                Button("Play Again") {
                        // Reset everything
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
            
            if isRound {
                Text("Round \(round)/5")
                    .padding()
            } else {
                Text("YourScore \(round)/5")
                    .padding()
            }
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
