import SwiftUI

struct ContentView: View {
    @State private var currentNumber = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0
    @State private var timeLeft = 5

    var body: some View {
        VStack(spacing: 25) {
            Text("Prime Number Game")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(currentNumber)")
                .font(.system(size: 72, weight: .bold))

            HStack(spacing: 20) {
                Button("Prime") {
                }
                .buttonStyle(.borderedProminent)

                Button("Not Prime") {
                }
                .buttonStyle(.bordered)
            }

            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))

            VStack(spacing: 10) {
                Text("Correct: \(correctCount)")
                Text("Wrong: \(wrongCount)")
                Text("Attempts: \(attemptCount)")
                Text("Time Left: \(timeLeft)")
            }
            .font(.title3)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
