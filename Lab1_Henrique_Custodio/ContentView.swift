//
//  ContentView.swift
//  Lab1_Henrique_Custodio
//
//  Created by Henrique Custodio on 3/15/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Prime Number Game")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("0")
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
                Text("Correct: 0")
                Text("Wrong: 0")
                Text("Attempts: 0")
                Text("Time Left: 5")
            }
            .font(.title3)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
