import SwiftUI

struct ContentView: View {
    @State private var picks = ["✊🏼", "✋🏼", "✌🏼"]
    @State private var options = ["Win", "Lose"]
    @State private var correctAnswers = [[1, 2, 0],[2, 0, 1]]
    @State private var pick = Int.random(in: 0...2)
    @State private var option = Int.random(in: 0...1)
    @State private var score = 0
    @State private var noQuestion = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var gameFinished = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .top, endPoint: .bottom)
            VStack {
                VStack{
                    Text("Oponent's choice")
                        .font(.title)
                    Text("\(picks[pick])")
                        .font(Font.system(size:100))
                }
                .padding()
                HStack{
                    Text("You need to")
                        .font(.body)
                    Text("\(options[option])")
                        .font(.body.bold())
                        .foregroundColor(options[option]=="Win" ? .green : .red)
                }
                HStack (spacing: 30){
                    ForEach(0..<3){ number in 
                        Button {
                            optionTapped(number)
                        } label: {
                            Text("\(picks[number])")
                        } 
                    }
                    .font(Font.system(size: 70))
                }
                .padding()
                Text("Score: \(score)")
                    .font(.title2)
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: generateQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .alert("Game Over!", isPresented: $gameFinished){
                Button("Retry", action: restartGame)
            } message: {
                Text("Your score is \(score)")
            }
        }
    }

    func optionTapped(_ number: Int) {
        if number == correctAnswers[option][pick] {
            score += 1
            scoreTitle = "Correct answer"
        }
        else{
            score -= 1
            scoreTitle = "Wrong answer"
        }
        noQuestion+=1
        showingScore = true
        if noQuestion==10 {
            gameFinished = true
        }
    }
    func generateQuestion() {
        pick = Int.random(in: 0...2)
        option = Int.random(in: 0...1)
    }
    func restartGame(){
        noQuestion=1
        score=0
        generateQuestion()
    }
}
