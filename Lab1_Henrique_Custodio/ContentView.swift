import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var logic = GameViewLogic()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let bgTop = Color(red: 0.03, green: 0.04, blue: 0.10)
    private let bgBottom = Color(red: 0.07, green: 0.02, blue: 0.13)

    private let neonBlue = Color(red: 0.22, green: 0.78, blue: 1.00)
    private let neonPink = Color(red: 1.00, green: 0.20, blue: 0.75)
    private let neonPurple = Color(red: 0.57, green: 0.33, blue: 0.95)

    private let cardFill = Color.white.opacity(0.07)
    private let cardStroke = Color.white.opacity(0.14)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    bgTop,
                    Color.black,
                    bgBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                Text("Prime Number Game")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                VStack(spacing: 10) {
                    Text("TARGET NUMBER")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(2)
                        .foregroundColor(neonBlue.opacity(0.9))

                    Text("\(logic.currentNumber)")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(cardFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(neonBlue.opacity(0.55), lineWidth: 1.5)
                        )
                )

                HStack(spacing: 16) {
                    Button("Prime") {
                        logic.answerSelected(true)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(neonBlue)
                    )
                    .foregroundColor(.black)

                    Button("Not Prime") {
                        logic.answerSelected(false)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(neonPink)
                    )
                    .foregroundColor(.white)
                }

                HStack(spacing: 14) {
                    Image(systemName: logic.result.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(logic.result.color)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(logic.roundStatusMessage)
                            .font(.headline)
                            .foregroundColor(logic.roundStatusColor)

                        Text("Time Left: \(logic.timeLeft)")
                            .font(.subheadline)
                            .foregroundColor(logic.timerColor)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(cardFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(cardStroke, lineWidth: 1)
                        )
                )

                VStack(spacing: 12) {
                    statRow(title: "Correct", value: logic.correctCount, valueColor: .green)
                    statRow(title: "Wrong", value: logic.wrongCount, valueColor: .red)
                    statRow(title: "Attempts", value: logic.attemptCount, valueColor: .white)
                    statRow(title: "Timed Out", value: logic.timeoutCount, valueColor: .orange)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(cardFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(neonPurple.opacity(0.45), lineWidth: 1)
                        )
                )

                Button("Reset Game") {
                    logic.resetGame()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(neonPurple)
                )
                .foregroundColor(.white)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            logic.startNewRound()
        }
        .onReceive(timer) { _ in
            logic.tick()
        }
        .alert("Progress Summary", isPresented: $logic.showSummaryDialog) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(logic.summaryMessage)
        }
    }

    private func statRow(title: String, value: Int, valueColor: Color) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color.white.opacity(0.85))

            Spacer()

            Text("\(value)")
                .fontWeight(.bold)
                .foregroundColor(valueColor)
        }
        .font(.title3)
    }
}

#Preview {
    ContentView()
}
