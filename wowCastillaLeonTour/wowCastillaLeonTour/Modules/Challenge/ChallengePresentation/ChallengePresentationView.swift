//
//  ChallengePresentationView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import SwiftUI
import Combine

struct ChallengePresentationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ChallengePresentationViewModel

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                       appState.currentView = .challengeList
                   }) {
                       HStack {
                           Image(systemName: "arrow.left")
                       }
                       .font(.headline)
                       .padding()
                       .background(Color.mateGold)
                       .foregroundColor(.black)
                       .cornerRadius(10)
                   }
                   .padding(.leading)
                
                if let challenge = viewModel.challenge {
                    Image(viewModel.userAvatar)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 40)

                    VStack(alignment: .leading) {
                        Text(challenge.challengeMessage)
                            .font(.title2)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                
                    Button(action: {
                        viewModel.beginChallenge()
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    appState.currentView = .map
                                case .failure(let error):
                                    viewModel.alertMessage = "Error updating challenge: \(error.localizedDescription)"
                                    viewModel.showAlert = true
                                }
                            }, receiveValue: { })
                            .store(in: &viewModel.cancellables)
                    }) {
                        Text("Comenzar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mateRed)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    Spacer()
                    
                } else {
                    Text("Cargando...")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Mensaje"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
}
