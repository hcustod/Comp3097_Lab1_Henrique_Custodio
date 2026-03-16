import SwiftUI
import Combine

struct ContentView: View {

    @State private var currentNumber = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0
    @State private var timeLeft = 5
    @State private var timeoutCount = 0

    @State private var result = Results.neutral
    @State private var showSummaryDialog = false
    @State private var roundActive = true
    @State private var didTimeoutLastRound = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var summaryMessage: String {
        Helpers.summaryMessage(
            correctCount: correctCount,
            wrongCount: wrongCount,
            timeoutCount: timeoutCount
        )
    }

    private var roundStatusMessage: String {
        Helpers.roundStatusMessage(
            attemptCount: attemptCount,
            didTimeoutLastRound: didTimeoutLastRound
        )
    }

    private var roundStatusColor: Color {
        Helpers.roundStatusColor(
            attemptCount: attemptCount,
            didTimeoutLastRound: didTimeoutLastRound
        )
    }

    var body: some View {
        VStack(spacing: 25) {

            Text("Prime Number Game")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(currentNumber)")
                .font(.system(size: 72, weight: .bold))

            HStack(spacing: 20) {

                Button("Prime") {
                    answerSelected(true)
                }
                .buttonStyle(.borderedProminent)

                Button("Not Prime") {
                    answerSelected(false)
                }
                .buttonStyle(.bordered)
            }

            Image(systemName: result.icon)
                .font(.system(size: 50))
                .foregroundStyle(result.color)

            Text(roundStatusMessage)
                .font(.headline)
                .foregroundStyle(roundStatusColor)

            VStack(spacing: 10) {
                Text("Correct: \(correctCount)")
                Text("Wrong: \(wrongCount)")
                Text("Attempts: \(attemptCount)")
                Text("Timed Out: \(timeoutCount)")
                Text("Time Left: \(timeLeft)")
            }
            .font(.title3)

        }
        .padding()
        .onAppear {
            startNewRound()
        }
        .onReceive(timer) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                handleTimeout()
            }
        }
        .alert("Progress Summary", isPresented: $showSummaryDialog) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(summaryMessage)
        }
    }

    private func startNewRound() {
        currentNumber = Helpers.generateNewNumber(previousNumber: currentNumber)
        timeLeft = 5
        roundActive = true
    }

    private func answerSelected(_ userSaysPrime: Bool) {
        guard roundActive else { return }

        roundActive = false
        didTimeoutLastRound = false

        let actualPrime = Helpers.isPrime(currentNumber)
        let isCorrect = userSaysPrime == actualPrime

        finishRound(correct: isCorrect)
    }

    private func handleTimeout() {
        guard roundActive else { return }

        roundActive = false
        didTimeoutLastRound = true
        timeoutCount += 1

        finishRound(correct: false)
    }

    private func finishRound(correct: Bool) {
        attemptCount += 1

        if correct {
            correctCount += 1
            result = .correct
        } else {
            wrongCount += 1
            result = .wrong
        }

        if attemptCount.isMultiple(of: 10) {
            showSummaryDialog = true
        }

        startNewRound()
    }
}

#Preview {
    ContentView()
}
