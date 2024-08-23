//
//  FillGapView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct FillGapView: View {
    @StateObject var viewModel: FillGapViewModel
    @EnvironmentObject var appState: AppState
    @State private var showAlert = false
    @State private var missingFieldsMessage = ""

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
                            if viewModel.userAnswers.contains(where: { $0.isEmpty }) {
                                alertUserToFillAllFields()
                            } else {
                                viewModel.submitAnswers()
                            }
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
                        Text("Cargando tarea...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let fillGap = viewModel.fillGap {
                        VStack(spacing: 20) {
                            Text(fillGap.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            AsyncImage(url: URL(string: fillGap.images)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 300)
                            } placeholder: {
                                ProgressView()
                                    .frame(maxWidth: 300)
                            }
                            
                            ForEach(0..<fillGap.correctPositions.count, id: \.self) { index in
                                TextField("Escribe aquí", text: $viewModel.userAnswers[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .background(Color.mateWhite.opacity(0.8))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultFillGapView(viewModel: viewModel)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Campos Incompletos"),
                        message: Text(missingFieldsMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
            }
            .onAppear {
                viewModel.fetchFillGap()
            }
        }
    }
    
    private func alertUserToFillAllFields() {
        let missingIndices = viewModel.userAnswers.enumerated()
            .filter { $0.element.isEmpty }
            .map { "Campo \($0.offset + 1)" }

        missingFieldsMessage = "Debes rellenar los siguientes campos:\n" + missingIndices.joined(separator: ", ")
        showAlert = true
    }
}

struct ResultFillGapView: View {
    @ObservedObject var viewModel: FillGapViewModel
    
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
    }
}

#Preview {
    FillGapView(viewModel: FillGapViewModel(activityId: "mockId"))
        .environmentObject(AppState())
}
