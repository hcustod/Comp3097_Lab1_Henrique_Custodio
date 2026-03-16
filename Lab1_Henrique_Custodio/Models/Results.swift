//
//  Results.swift
//  Lab1_Henrique_Custodio
//
//  Created by Henrique Custodio on 3/15/26.
//
import SwiftUI

struct Results: Equatable {
    let icon: String
    let color: Color

    static let neutral = Results(
        icon: "questionmark.circle",
        color: .gray
    )

    static let correct = Results(
        icon: "checkmark.circle.fill",
        color: .green
    )

    static let wrong = Results(
        icon: "xmark.circle.fill",
        color: .red
    )

    static let timedOut = Results(
        icon: "clock.badge.xmark",
        color: .orange
    )
}
