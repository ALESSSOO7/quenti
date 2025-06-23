import SwiftUI

struct FlashcardView: View {
    let term: Term
    /// Called when the card has been swiped far enough. `true` for right swipes,
    /// `false` for left.
    var onSwipe: (Bool) -> Void

    @State private var showingDefinition = false
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 4)
                )

            Text(showingDefinition ? term.definition : term.word)
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)

            if offset.width > 80 {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green.opacity(0.7))
                    .offset(x: -40)
            } else if offset.width < -80 {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red.opacity(0.7))
                    .offset(x: 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .animation(.spring(), value: offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    if abs(gesture.translation.width) > 100 {
                        let correct = gesture.translation.width > 0
                        withAnimation {
                            offset = CGSize(width: gesture.translation.width * 2, height: 0)
                        }
                        onSwipe(correct)
                    } else {
                        withAnimation { offset = .zero }
                    }
                }
        )
        .onTapGesture { showingDefinition.toggle() }
    }

    private var borderColor: Color {
        if offset.width > 50 { return .green }
        if offset.width < -50 { return .red }
        return .clear
    }
}

#Preview {
    FlashcardView(term: Term(word: "Hola", definition: "Hello")) { _ in }
}
