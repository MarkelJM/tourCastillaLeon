//
//  QuestionAnswerView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct QuestionAnswerView: View {
    @StateObject var viewModel: QuestionAnswerViewModel
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
                            Text("Cargando pregunta...")
                                .font(.title2)
                                .foregroundColor(.mateWhite)
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else if let questionAnswer = viewModel.questionAnswer {
                            VStack(spacing: 20) {
                                Text(questionAnswer.question)
                                    .font(.title2)
                                    .foregroundColor(.mateGold)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                ForEach(questionAnswer.options, id: \.self) { option in
                                    Button(action: {
                                        viewModel.selectedOption = option
                                    }) {
                                        Text(option)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(viewModel.selectedOption == option ? Color.mateGreen : Color.mateBlue)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                    .cornerRadius(20)
                    .padding()
                    .sheet(isPresented: $viewModel.showResultModal) {
                        ResultQuestionView(viewModel: viewModel)
                            .environmentObject(appState)  // Pasar appState al resultado también
                    }
                
            }
            .onAppear {
                viewModel.fetchQuestionAnswer()
            }
        }
    }
}

#Preview {
    QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: "mockId", appState: AppState()))
        .environmentObject(AppState())
}

struct ResultQuestionView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel
    @EnvironmentObject var appState: AppState

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

                Button(action: {
                    viewModel.showResultModal = false
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


