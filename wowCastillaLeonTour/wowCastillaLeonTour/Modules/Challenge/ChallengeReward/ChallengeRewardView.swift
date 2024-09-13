//
//  ChallengeRewardView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 27/8/24.
//

import SwiftUI

struct ChallengeRewardView: View {
    @ObservedObject var viewModel: ChallengeRewardViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    Text("Cargando datos...")
                        .font(.title2)
                        .foregroundColor(.white)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let reward = viewModel.challengeReward {
                    ARViewContainer(prizeImageName: reward.prizeImage, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No hay datos disponibles")
                        .foregroundColor(.white)
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .map
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .padding()
                            .background(Color.mateGold)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultChallengeRewardView(viewModel: viewModel)
                .environmentObject(appState)
        }
    }
}


struct ResultChallengeRewardView: View {
    @ObservedObject var viewModel: ChallengeRewardViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared 

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.resultMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                Button("Continuar") {
                    viewModel.showResultModal = false
                    appState.currentView = .map
                }
                .padding()
                .background(Color.mateRed)
                .foregroundColor(.mateWhite)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound() 
        }
        
    }
}
