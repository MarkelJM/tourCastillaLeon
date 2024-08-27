//
//  SpecialPrizeTaskView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

/*
import SwiftUI
import ARKit
import RealityKit

struct SpecialPrizeTaskView: View {
    @ObservedObject var viewModel: SpecialPrizeTaskViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if let specialPrize = viewModel.specialPrize {
                    ARViewContainer(prizeImageName: specialPrize.image, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("Cargando...")
                        .font(.largeTitle)
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
            ResultSpecialPrizeView(viewModel: viewModel)
                .environmentObject(appState)
        }
    }
}

struct ResultSpecialPrizeView: View {
    @ObservedObject var viewModel: SpecialPrizeTaskViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.alertMessage) // Mostrar el mensaje de la tarea completada
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                Button("Continuar") {
                    // Cerrar el modal y volver al mapa
                    viewModel.showResultModal = false
                    appState.currentView = .map
                }
                .padding()
                .background(Color.mateRed)
                .foregroundColor(.mateWhite)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.5))  // Fondo semitransparente del VStack
            .cornerRadius(20)
            .padding()
        }
    }
}
*/
