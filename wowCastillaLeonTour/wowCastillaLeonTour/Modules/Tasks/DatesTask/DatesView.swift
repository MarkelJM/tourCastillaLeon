//
//  DatesView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct DatesOrderView: View {
    @StateObject var viewModel: DatesOrderViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            ZStack {
                // Fondo de pantalla
                Image("fondoSolar")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    
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
                        Button(action: {
                            viewModel.checkAnswer()
                        }) {
                            Text("Comprobar")
                                .padding()
                                .background(Color.mateRed)
                                .foregroundColor(.mateWhite)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando eventos...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let dateEvent = viewModel.dateEvent {
                        VStack(spacing: 20) {
                            Text(dateEvent.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            ForEach(viewModel.shuffledOptions, id: \.self) { option in
                                Button(action: {
                                    viewModel.selectEvent(option)
                                }) {
                                    Text(option)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(viewModel.selectedEvents.contains(option) ? Color.mateGreen : Color.mateBlue)
                                        .cornerRadius(10)
                                }
                            }
                            HStack {
                                Button(action: {
                                    viewModel.checkAnswer()
                                }) {
                                    Text("Comprobar")
                                        .padding()
                                        .background(Color.mateRed)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                }

                                // Botón de deshacer selección
                                Button(action: {
                                    viewModel.undoSelection()
                                }) {
                                    Text("Deshacer")
                                        .padding()
                                        .background(Color.mateRed)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultDatesOrderView(viewModel: viewModel)
                }
                
            }
            .onAppear {
                viewModel.fetchDateEvent()
            }
        }
    }
}

struct ResultDatesOrderView: View {
    @ObservedObject var viewModel: DatesOrderViewModel
    let soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                if let informationDetail = viewModel.dateEvent?.informationDetail {
                    Text(informationDetail)  // Mostrar el campo informationDetail
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Button(action: {
                    viewModel.showResultAlert = false
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
        }
    }
}

#Preview {
    DatesOrderView(viewModel: DatesOrderViewModel(activityId: "mockId", appState: AppState()))
        .environmentObject(AppState())
}
