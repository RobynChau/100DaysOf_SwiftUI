import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    let card: Card
    
    let retryIncorrectCards: Bool
    private var shouldResetPosition: Bool {
        offset.width < 0 && retryIncorrectCards
    }
    
    var removal: ((_ isCorrect: Bool) -> Void)?
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(getBackgroundColor(offset: offset))
                )
                .shadow(radius: 10)
            VStack{
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.promp)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else{
                    Text(card.promp)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width < 0 {
                            feedback.notificationOccurred(.error)
                        }
                        removal?(offset.width > 0)
                        if shouldResetPosition {
                            isShowingAnswer = false
                            offset = .zero
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
    
    func getBackgroundColor(offset: CGSize) -> Color {
        if offset.width > 0 {
            return .green
        } else if offset.width < 0 {
            return .red
        } else {
            return .white
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example, retryIncorrectCards: true)
    }
}
