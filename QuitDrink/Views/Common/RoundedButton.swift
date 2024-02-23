//
//  RoundedButton.swift
//  QuitDrink
//
//  Created by Georgii Fesenko on 23.02.2024.
//

import SwiftUI

struct RoundedButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
        .padding()
        .foregroundColor(.blue)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}
