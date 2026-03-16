//
//  Helpers.swift
//  Lab1_Henrique_Custodio
//
//  Created by Henrique Custodio on 3/15/26.
//
import Foundation

enum Helpers {

    static func generateNewNumber(previousNumber: Int, range: ClosedRange<Int> = 1...100) -> Int {
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

}

