//
//  SpecialPrizeTaskView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//


import SwiftUI

struct SpecialPrizeTaskView: View {
    @ObservedObject var viewModel: SpecialPrizeTaskViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            if let specialPrize = viewModel.specialPrize {
                ARViewContainer(prizeImageName: specialPrize.image, viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            appState.currentView = .map
                        }) {
                            Text("Atrás")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding([.top, .leading], 20)
                    
                    Spacer()
                }
            } else {
                Text("Cargando...")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultSpecialPrizeView(viewModel: viewModel) // No pasamos _appState aquí
                .environmentObject(appState) // Inyectamos appState como EnvironmentObject
        }
    }
}

struct ResultSpecialPrizeView: View {
    @ObservedObject var viewModel: SpecialPrizeTaskViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text(viewModel.alertMessage) // Mostrar el mensaje de la tarea completada
                .font(.title)
                .padding()

            Button("Continuar") {
                // Cerrar el modal y volver al mapa
                viewModel.showResultModal = false
                appState.currentView = .map
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
