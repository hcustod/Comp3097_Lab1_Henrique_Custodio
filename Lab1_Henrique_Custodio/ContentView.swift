import SwiftUI
internal import Combine

let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct ContentView: View {
    @State private var currentNumber = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0
    @State private var timeLeft = 5
    
    @State private var resultIcon = "questionmark.circle"
    @State private var resultColor = Color.gray

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
    }

    func generateNewNumber() {
        currentNumber = Int.random(in: 1...100)
    }
    
    func answerSelected(_ userSaysPrime: Bool) {
        let actualPrime = isPrime(currentNumber)
        let isCorrect = userSaysPrime == actualPrime

        attemptCount += 1

        if isCorrect {
            correctCount += 1
            resultIcon = "checkmark.circle.fill"
            resultColor = .green
        } else {
            wrongCount += 1
            resultIcon = "xmark.circle.fill"
            resultColor = .red
        }

        generateNewNumber()
        timeLeft = 5
    }
    
    func isPrime(_ number: Int) -> Bool {
        if number < 2 { return false }
        if number == 2 { return true }
        if number % 2 == 0 { return false }

        let limit = Int(Double(number).squareRoot())

        for i in stride(from: 3, through: limit, by: 2) {
            if number % i == 0 {
                return false
            }
        }

        return true
    }
    
    func handleTimeout() {
        attemptCount += 1
        wrongCount += 1
        resultIcon = "xmark.circle.fill"
        resultColor = .red
        generateNewNumber()
        timeLeft = 5
    }
}

#Preview {
    ContentView()
}




