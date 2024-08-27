//
//  ChallengeSelectionView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 25/8/24.
//

import SwiftUI



struct ChallengeSelectionView: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack {
            Text("Selecciona un reto")
                .font(.headline)
            Picker("Reto", selection: $viewModel.selectedChallenge) {
                Text("Reto Básico").tag("retoBasico")
                Text("Reto Capital Burgos").tag("retoCapitalBurgos")
                Text("Reto Norte Burgos").tag("retoNorteBurgos")
                Text("Reto Sur Burgos").tag("retoSurBurgos")
                // Añade más opciones según sea necesario
            }
            .pickerStyle(WheelPickerStyle())

            Button(action: {
                viewModel.beginChallenge()
                viewModel.fetchSpots()
                viewModel.showChallengeSelection = false
            }) {
                Text("Comenzar Reto")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

/*
#Preview {
    ChallengeSelectionView()
}
*/
