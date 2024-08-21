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
    
    var body: some View {
        VStack {
            Button("Atrás") {
                appState.currentView = .map
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if viewModel.isLoading {
                Text("Cargando tarea...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let fillGap = viewModel.fillGap {
                VStack(spacing: 20) {
                    Text(fillGap.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
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
                    }
                    
                    Button("Comprobar") {
                        if viewModel.userAnswers.contains(where: { $0.isEmpty }) {
                            alertUserToFillAllFields()
                        } else {
                            viewModel.submitAnswers()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultFillGapView(viewModel: viewModel)
                }
            } else {
                Text("No hay tarea disponible")
            }
        }
        .onAppear {
            viewModel.fetchFillGap()
        }
    }
    
    private func alertUserToFillAllFields() {
        // show alert
    }
}

struct ResultFillGapView: View {
    @ObservedObject var viewModel: FillGapViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.alertMessage)
                .font(.title)
                .padding()

            Button("Continuar") {
                viewModel.showResultAlert = false
               
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct FillGapView_Previews: PreviewProvider {
    static var previews: some View {
        FillGapView(viewModel: FillGapViewModel(activityId: "mockId"))
    }
}
