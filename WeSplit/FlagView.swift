    //
    //  FlagView.swift
    //  WeSplit
    //
    //  Created by Hafizur Rahman on 2/11/25.
    //

import SwiftUI

struct FlagView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var scoreTitle: String = ""
    @State private var totalScore: Int = 0
    @State private var isPresented: Bool = false
    @State private var isReset: Bool = false
    @State private var trigger: Bool = false
    @State private var questionCount: Int = 0
    
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.878, green: 0.42, blue: 0.447), location: 0.3),
                .init(color: Color(red: 0.122, green: 0.129, blue: 0.18), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Guss the right flag")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 24) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.primary)
                            .font(.subheadline.weight(.bold))
                        
                        Text("\(countries[correctAnswer])")
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach (0..<3) { number in
                        Button {
                            checkAnswer(number)
                            questionCount += 1
                            trigger.toggle()
                            
                            if questionCount == 8 {
                               isReset = true
                            }
                        } label:  {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(color: .black, radius: 5)
                            
                        }
                        .sensoryFeedback(.increase, trigger: trigger)
                    }
                    
                    
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                Text("Your total score: \(totalScore)/8")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Text("Question left: \(8 - questionCount)/8")
                    .foregroundStyle(.white)
                    .font(.body.bold())
                Spacer()
            }
            .padding()
            
            .alert("Reseat for new round", isPresented: $isReset) {
                Button("Confirm") {
                    isReset = false
                    totalScore = 0
                    questionCount = 0
                }
            } message: {
                Text("Your total Score is \(totalScore)")
            }
            
            .alert(scoreTitle, isPresented: $isPresented) {
                Button("Continue") {
                    changeQuesion()
                    isPresented.toggle()
                }
            } message: {
                Text("Your total Score is \(totalScore)")
            }
        }
    }
    
    
    func checkAnswer(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong"
        }
        isPresented.toggle()
    }
    
    func changeQuesion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    FlagView()
}
