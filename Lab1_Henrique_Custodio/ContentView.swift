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

    private var timerColor: Color {
        if timeLeft <= 1 {
            return .red
        } else if timeLeft <= 2 {
            return .orange
        } else {
            return .cyan
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.08, green: 0.02, blue: 0.16),
                    Color(red: 0.02, green: 0.08, blue: 0.14)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                Text("Prime Number Game")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                VStack(spacing: 10) {
                    Text("TARGET NUMBER")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(2)
                        .foregroundStyle(.cyan.opacity(0.85))

                    Text("\(currentNumber)")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.cyan.opacity(0.6), lineWidth: 1.5)
                        )
                )

                HStack(spacing: 16) {
                    Button("Prime") {
                        answerSelected(true)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.cyan.opacity(0.9))
                    )
                    .foregroundStyle(.black)

                    Button("Not Prime") {
                        answerSelected(false)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.pink.opacity(0.9))
                    )
                    .foregroundStyle(.white)
                }

                HStack(spacing: 14) {
                    Image(systemName: result.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(result.color)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(roundStatusMessage)
                            .font(.headline)
                            .foregroundStyle(roundStatusColor)

                        Text("Time Left: \(timeLeft)")
                            .font(.subheadline)
                            .foregroundStyle(timerColor)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.07))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )

                VStack(spacing: 12) {
                    statRow(title: "Correct", value: correctCount, valueColor: .green)
                    statRow(title: "Wrong", value: wrongCount, valueColor: .red)
                    statRow(title: "Attempts", value: attemptCount, valueColor: .white)
                    statRow(title: "Timed Out", value: timeoutCount, valueColor: .orange)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.purple.opacity(0.35), lineWidth: 1)
                        )
                )

                Spacer()
            }
            .padding()
        }
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

    private func statRow(title: String, value: Int, valueColor: Color) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.white.opacity(0.85))

            Spacer()

            Text("\(value)")
                .fontWeight(.bold)
                .foregroundStyle(valueColor)
        }
        .font(.title3)
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
