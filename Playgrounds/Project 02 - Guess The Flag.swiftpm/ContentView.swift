import SwiftUI

//This is a view for project 3
struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
        .renderingMode(.original)
        .clipShape(RoundedRectangle(cornerRadius: 80))
        .shadow(radius: 5)
    }
}

//This is a ViewModifier and extension for project 3
struct ProminentTitle : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func ProminentTitleStyle() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var finalQuestion = false
    @State private var noQuestion = 0
    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess The Flag")
//                    .font(.largeTitle.bold())
//                    .foregroundColor(.white)
                    .ProminentTitleStyle()
                Text("Question No. \(noQuestion+1)")
                    .font(.title.bold())
                    .foregroundStyle(.secondary)
                VStack (spacing: 15) {
                    VStack{
                        Text("Tap the flaf of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in 
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .alert("Game Over! You scored \(score)", isPresented: $finalQuestion) {
                Button("Restart", action: restartGame)
            }
        }
    }
    func flagTapped (_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score+=1
        }
        else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        noQuestion+=1
        showingScore = true
        if (noQuestion==8){
            finalQuestion=true
        }
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer=Int.random(in: 0...2)
    }
    func restartGame() {
        countries.shuffle()
        correctAnswer=Int.random(in: 0...2)
        scoreTitle=""
        score=0
        finalQuestion=false
        showingScore=false
        noQuestion=0
    }
}

