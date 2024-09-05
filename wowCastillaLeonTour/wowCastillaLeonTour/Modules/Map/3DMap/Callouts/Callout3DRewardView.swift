//
//  Callout3DRewardView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 3/9/24.
//


/*
import SwiftUI

struct Callout3DRewardView: View {
    var reward: ChallengeReward
    var challenge: String
    @ObservedObject var viewModel: Map3DViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text(reward.challengeTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.mateGold)
            
            Text(reward.abstract)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            AsyncImage(url: URL(string: reward.prizeImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }

            Button(action: {
                appState.currentView = .challengeReward(challengeName: reward.challenge)
            }) {
                Text("Obtener Recompensa")
                    .font(.headline)
                    .foregroundColor(.mateWhite)
                    .padding()
                    .background(Color.mateGold)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Spacer()
        }
        .padding()
        .background(Color.mateWhite.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
*/
