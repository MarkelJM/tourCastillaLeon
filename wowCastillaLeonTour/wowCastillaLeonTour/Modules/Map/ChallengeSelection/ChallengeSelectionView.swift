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
                .font(.title)
                .padding()

            List(viewModel.challenges, id: \.id) { challenge in
                Button(action: {
                    viewModel.selectedChallenge = challenge.challengeName
                    viewModel.beginChallenge()  // Aquí se guarda en UserDefaults
                    viewModel.fetchSpots()
                    viewModel.showChallengeSelection = false
                }) {
                    Text(challenge.challengeTitle)
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }
}
