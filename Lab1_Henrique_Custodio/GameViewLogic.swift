//
//  GameViewLogic.swift
//  Lab1_Henrique_Custodio
//
//  Created by Henrique Custodio on 3/15/26.
//
import SwiftUI
import Combine

final class GameViewLogic: ObservableObject {

    @Published var currentNumber = 0
    @Published var correctCount = 0
    @Published var wrongCount = 0
    @Published var attemptCount = 0
    @Published var timeLeft = 5
    @Published var timeoutCount = 0

    @Published var result = Results.neutral
    @Published var showSummaryDialog = false
    @Published var roundActive = true
    @Published var didTimeoutLastRound = false

    var summaryMessage: String {
        Helpers.summaryMessage(
            correctCount: correctCount,
            wrongCount: wrongCount,
            timeoutCount: timeoutCount
        )
    }

    var roundStatusMessage: String {
        Helpers.roundStatusMessage(
            attemptCount: attemptCount,
            didTimeoutLastRound: didTimeoutLastRound
        )
    }

    var roundStatusColor: Color {
        Helpers.roundStatusColor(
            attemptCount: attemptCount,
            didTimeoutLastRound: didTimeoutLastRound
        )
    }

    var timerColor: Color {
        if timeLeft <= 1 {
            return .red
        } else if timeLeft <= 2 {
            return .orange
        } else {
            return .cyan
        }
    }

    func startNewRound() {
        currentNumber = Helpers.generateNewNumber(previousNumber: currentNumber)
        timeLeft = 5
        roundActive = true
    }

    func tick() {
        if timeLeft > 0 {
            timeLeft -= 1
        } else {
            handleTimeout()
        }
    }

    func answerSelected(_ userSaysPrime: Bool) {

        guard roundActive else { return }

        roundActive = false
        didTimeoutLastRound = false

        let actualPrime = Helpers.isPrime(currentNumber)
        let isCorrect = userSaysPrime == actualPrime

        finishRound(correct: isCorrect)
    }

    func handleTimeout() {

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
