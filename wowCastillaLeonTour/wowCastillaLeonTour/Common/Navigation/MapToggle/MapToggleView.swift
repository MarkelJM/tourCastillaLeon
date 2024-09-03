//
//  MapToggleView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//


import SwiftUI

struct MapToggleView: View {
    @State private var is3DView = false
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward? // Añadir esta línea
    @StateObject private var viewModel = Map3DViewModel(appState: AppState()) // Crear instancia del ViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if is3DView {
                Map3DView(selectedSpot: $selectedSpot, selectedReward: $selectedReward, viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Map2DView()
                    .edgesIgnoringSafeArea(.all)
            }

            Button(action: {
                is3DView.toggle()
            }) {
                Text(is3DView ? "Cambiar a 2D" : "Cambiar a 3D")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    .padding()
            }
            .padding(.bottom, 20)
            .padding(.trailing, 20)
        }
    }
}

/*
import SwiftUI

struct MapToggleView: View {
    @State private var is3DView = false
    @State private var selectedSpot: Spot?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if is3DView {
                Map3DView(selectedSpot: $selectedSpot)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Map2DView()
                    .edgesIgnoringSafeArea(.all)
            }

            Button(action: {
                is3DView.toggle()
            }) {
                Text(is3DView ? "Cambiar a 2D" : "Cambiar a 3D")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    .padding()
            }
            .padding(.bottom, 20)
            .padding(.trailing, 20)
        }
    }
}
*/
