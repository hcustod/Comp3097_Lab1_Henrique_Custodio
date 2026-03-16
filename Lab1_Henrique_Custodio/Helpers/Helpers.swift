//
//  Helpers.swift
//  Lab1_Henrique_Custodio
//
//  Created by Henrique Custodio on 3/15/26.
//
import SwiftUI
import Foundation

enum Helpers {

    static func generateNewNumber(
        previousNumber: Int,
        range: ClosedRange<Int> = 1...100
    ) -> Int {
        var newNumber = Int.random(in: range)

        while newNumber == previousNumber {
            newNumber = Int.random(in: range)
        }

        return newNumber
    }

    static func isPrime(_ number: Int) -> Bool {
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

    static func summaryMessage(
        correctCount: Int,
        wrongCount: Int,
        timeoutCount: Int
    ) -> String {
        """
        Correct: \(correctCount)
        Wrong: \(wrongCount)
        Timed Out: \(timeoutCount)
        """
    }

    static func roundStatusMessage(
        attemptCount: Int,
        didTimeoutLastRound: Bool
    ) -> String {
        if attemptCount == 0 {
            return "No rounds played yet"
        }

        return didTimeoutLastRound
            ? "Previous round: Timed out"
            : "Previous round: Answer submitted"
    }

    static func roundStatusColor(
        attemptCount: Int,
        didTimeoutLastRound: Bool
    ) -> Color {
        if attemptCount == 0 {
            return .gray
        }

        return didTimeoutLastRound ? .orange : .blue
    }

    static func timerColor(for timeLeft: Int) -> Color {
        if timeLeft <= 1 {
            return .red
        } else if timeLeft <= 2 {
            return .orange
        } else {
            return .cyan
        }
    }

    static func shouldShowSummary(for attemptCount: Int) -> Bool {
        attemptCount.isMultiple(of: 10)
    }
}
