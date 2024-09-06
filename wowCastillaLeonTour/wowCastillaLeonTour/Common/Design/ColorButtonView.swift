//
//  ColorButtonView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/7/24.
//

import SwiftUI

// Botón con fondo blanco y borde rojo
func whiteBackgroundButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateRed)
            .padding()
            .background(
                Capsule()
                    .fill(Color.mateWhite)
            )
            .overlay(
                Capsule()
                    .stroke(Color.mateRed, lineWidth: 2)
            )
    }
}

// Botón con fondo rojo y borde blanco
func redBackgroundButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateWhite)
            .padding()
            .background(
                Capsule()
                    .fill(Color.mateRed)
            )
            .overlay(
                Capsule()
                    .stroke(Color.mateWhite, lineWidth: 2)
            )
    }
}
