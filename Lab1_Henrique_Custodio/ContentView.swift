import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var logic = GameViewLogic()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

                    Text("\(logic.currentNumber)")
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
                        logic.answerSelected(true)
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
                        logic.answerSelected(false)
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
                    Image(systemName: logic.result.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(logic.result.color)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(logic.roundStatusMessage)
                            .font(.headline)
                            .foregroundStyle(logic.roundStatusColor)

                        Text("Time Left: \(logic.timeLeft)")
                            .font(.subheadline)
                            .foregroundStyle(logic.timerColor)
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
                    statRow(title: "Correct", value: logic.correctCount, valueColor: .green)
                    statRow(title: "Wrong", value: logic.wrongCount, valueColor: .red)
                    statRow(title: "Attempts", value: logic.attemptCount, valueColor: .white)
                    statRow(title: "Timed Out", value: logic.timeoutCount, valueColor: .orange)
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
                
                Button("Reset Game") {
                    logic.resetGame()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.purple.opacity(0.9))
                )
                .foregroundStyle(.white)

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
                .foregroundStyle(Color.white.opacity(0.85))

            Spacer()

            Text("\(value)")
                .fontWeight(.bold)
                .foregroundStyle(valueColor)
        }
        .font(.title3)
    }
}

#Preview {
    ContentView()
}
