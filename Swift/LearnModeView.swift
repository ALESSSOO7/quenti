import SwiftUI
import SwiftData
#if canImport(SwiftLevenshtein)
import SwiftLevenshtein
#endif

struct LearnModeView: View {
    enum Mode { case multipleChoice, written, finished }

    let set: StudySet
    @State private var index: Int = 0
    @State private var correct: Int = 0
    @State private var mode: Mode = .multipleChoice
    @State private var userAnswer: String = ""

    var body: some View {
        VStack {
            switch mode {
            case .multipleChoice:
                multipleChoice
            case .written:
                writtenQuiz
            case .finished:
                resultView
            }
        }
        .navigationTitle(set.title)
        .animation(.default, value: mode)
    }

    // MARK: - Views
    private var multipleChoice: some View {
        let term = set.terms[index]
        return VStack(spacing: 20) {
            Text(term.word)
                .font(.title)
            ForEach(options(for: term), id: \.self) { option in
                Button(action: { select(option, for: term) }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    private var writtenQuiz: some View {
        let term = set.terms[index]
        return VStack(spacing: 16) {
            Text(term.word)
                .font(.title)
            TextField("Answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
            Button("Check") { checkWritten(for: term) }
        }
        .padding()
    }

    private var resultView: some View {
        VStack(spacing: 16) {
            Text("Great job!")
                .font(.title)
            Text("Score: \(correct)/\(set.terms.count * 2)")
                .font(.headline)
        }
        .padding()
    }

    // MARK: - Logic
    private func options(for term: Term) -> [String] {
        var pool = set.terms.map { $0.definition }
        pool.removeAll { $0 == term.definition }
        let extras = pool.shuffled().prefix(3)
        return ([term.definition] + extras).shuffled()
    }

    private func select(_ option: String, for term: Term) {
        if option == term.definition { correct += 1 }
        nextQuestion()
    }

    private func checkWritten(for term: Term) {
        let target = term.definition.lowercased()
        let answer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let distance = levenshtein(answer, target)
        let tolerance = max(1, Int(Double(target.count) * 0.2))
        if distance <= tolerance { correct += 1 }
        userAnswer = ""
        nextQuestion()
    }

    private func nextQuestion() {
        index += 1
        if index >= set.terms.count {
            index = 0
            switch mode {
            case .multipleChoice:
                mode = .written
            case .written:
                mode = .finished
            case .finished:
                break
            }
        }
    }

    /// Calculate the Levenshtein edit distance. When the optional
    /// SwiftLevenshtein package is available we use it directly; otherwise a
    /// simple dynamic programming implementation acts as a fallback.
    private func levenshtein(_ lhs: String, _ rhs: String) -> Int {
#if canImport(SwiftLevenshtein)
        return SwiftLevenshtein.distance(between: lhs, and: rhs)
#else
        let lhs = Array(lhs)
        let rhs = Array(rhs)
        var dist = Array(repeating: Array(repeating: 0, count: rhs.count + 1), count: lhs.count + 1)
        for i in 0...lhs.count { dist[i][0] = i }
        for j in 0...rhs.count { dist[0][j] = j }
        for i in 1...lhs.count {
            for j in 1...rhs.count {
                if lhs[i-1] == rhs[j-1] {
                    dist[i][j] = dist[i-1][j-1]
                } else {
                    dist[i][j] = min(dist[i-1][j] + 1,
                                     dist[i][j-1] + 1,
                                     dist[i-1][j-1] + 1)
                }
            }
        }
        return dist[lhs.count][rhs.count]
#endif
    }
}

#Preview {
    let set = StudySet(title: "Spanish", description: "Basics", terms: [
        Term(word: "hola", definition: "hello"),
        Term(word: "adiós", definition: "goodbye"),
        Term(word: "gracias", definition: "thanks"),
        Term(word: "por favor", definition: "please")
    ])
    return LearnModeView(set: set)
}
