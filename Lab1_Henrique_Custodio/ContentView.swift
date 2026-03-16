import SwiftUI
internal import Combine

struct ContentView: View {
    @State private var currentNumber = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0
    @State private var timeLeft = 5

    @State private var resultIcon = "questionmark.circle"
    @State private var resultColor = Color.gray
    @State private var showSummaryDialog = false
    @State private var roundActive = true
    @State private var didTimeoutLastRound = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var summaryMessage: String {
        "Correct: \(correctCount)\nWrong: \(wrongCount)"
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

            Image(systemName: resultIcon)
                .font(.system(size: 50))
                .foregroundStyle(resultColor)

            VStack(spacing: 10) {
                Text("Correct: \(correctCount)")
                Text("Wrong: \(wrongCount)")
                Text("Attempts: \(attemptCount)")
                Text("Time Left: \(timeLeft)")
            }
            .font(.title3)
        }
        .padding()
        .onAppear {
            generateNewNumber()
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

    private func generateNewNumber() {
        let previousNumber = currentNumber
        var newNumber = Int.random(in: 1...100)

        while newNumber == previousNumber {
            newNumber = Int.random(in: 1...100)
        }

        currentNumber = newNumber
        timeLeft = 5
        roundActive = true
        didTimeoutLastRound = false
    }

    private func answerSelected(_ userSaysPrime: Bool) {
        guard roundActive else { return }
        roundActive = false
        didTimeoutLastRound = false

        let actualPrime = isPrime(currentNumber)
        let isCorrect = userSaysPrime == actualPrime

        finishRound(correct: isCorrect)
    }

    private func handleTimeout() {
        guard roundActive else { return }
        roundActive = false
        didTimeoutLastRound = true

        finishRound(correct: false)
    }

    private func finishRound(correct: Bool) {
        attemptCount += 1

        if correct {
            correctCount += 1
            resultIcon = "checkmark.circle.fill"
            resultColor = .green
        } else {
            wrongCount += 1
            resultIcon = "xmark.circle.fill"
            resultColor = .red
        }

        if attemptCount.isMultiple(of: 10) {
            showSummaryDialog = true
        }

        generateNewNumber()
    }

    private func isPrime(_ number: Int) -> Bool {
        if number < 2 { return false }
        if number == 2 { return true }
        if number.isMultiple(of: 2) { return false }

        let limit = Int(Double(number).squareRoot())

        for i in stride(from: 3, through: limit, by: 2) {
            if number.isMultiple(of: i) {
                return false
            }
        }

        return true
    }
}

#Preview {
    ContentView()
}
