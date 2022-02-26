import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    enum SheetType {
        case editCards, settings
    }
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var cards = [Card]()
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingSheet = false
    
    @State private var sheetType = SheetType.editCards
    
    @State private var retryIncorrectCards = false
    
    @State private var initialCardsCount = 0
    @State private var correctCards = 0
    @State private var incorrectCards = 0
    private var reviewedCards: Int {
        correctCards + incorrectCards
    }
    
    var body: some View {
        ZStack{
            Image("background@3x")
                .resizable()
                .ignoresSafeArea()
            VStack{
                
                HStack{
                    Text("Time:")
                    Text("\(timeRemaining)")
                        .foregroundColor(timeRemaining < 10 ? .red : .white)
                }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack{
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index], retryIncorrectCards: retryIncorrectCards){ isCorrect in
                            if isCorrect {
                                correctCards += 1
                            } else {
                                incorrectCards += 1
                                
                                if retryIncorrectCards {
                                    self.restackedCard(at: index)
                                    return
                                }
                            }
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                            .stacked(at: index, in: cards.count)
                            .allowsHitTesting(index == cards.count - 1)
                            .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    RestartView(retryIncorrectCards: retryIncorrectCards, initialCardsCount: initialCardsCount, reviewedCards: reviewedCards, correctCards: correctCards, incorrectCards: incorrectCards, restartAction: resetCards)
                        .frame(width: 450, height: 250)
                }
            }
            
            VStack{
                HStack {
                    Button{
                        sheetType = .settings
                        showingSheet = true
                    } label: {
                        Image(systemName: "gear")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        sheetType = .editCards
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack{
                    Spacer()
                    
                    HStack{
                        Button {
                            incorrectCards += 1
                            
                            if retryIncorrectCards {
                                restackedCard(at: cards.count - 1)
                                return
                            }
                            
                            withAnimation{
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        Spacer()
                        
                        Button {
                            withAnimation{
                                removeCard(at: cards.count - 1)
                                correctCards += 1
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else {return}
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: resetCards) {
            if sheetType == .editCards {
                EditCard()
            } else if sheetType == .settings {
                SettingView(retryIncorrectCards: $retryIncorrectCards)
            }
        }
        .onAppear(perform: resetCards)
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                cards = decoded
                
                initialCardsCount = cards.count
                correctCards = 0
                incorrectCards = 0
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else {return}
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func restackedCard(at index: Int){
        guard index >= 0 else {return}
        
        let card = cards[index]
        cards.remove(at: index)
        cards.insert(card, at: 0)
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}
