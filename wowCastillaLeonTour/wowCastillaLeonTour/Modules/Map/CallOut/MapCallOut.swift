//
//  MapCallOut.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/7/24.
//

import SwiftUI

struct MapCallOutView: View {
    var spot: Spot
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(spot.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.mateRed)
            
            Text(spot.abstract)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            AsyncImage(url: URL(string: spot.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
            }
            .padding(.horizontal)

            Button(action: {
                if viewModel.isTaskCompleted(taskID: spot.activityID, activityType: spot.activityType, challenge: viewModel.selectedChallenge) {
                    viewModel.alertMessage = "Esta tarea ya está completada."
                    viewModel.showAlert = true
                } else {
                    print("Participar button tapped for \(spot.name)")
                    
                    // Guardar el spotID en UserDefaults
                    viewModel.saveSpotID(spot.id)
                    
                    switch spot.activityType {
                    case "puzzles":
                        appState.currentView = .puzzle(id: spot.activityID)
                    case "coins":
                        appState.currentView = .coin(id: spot.activityID)
                    case "dates":
                        appState.currentView = .dates(id: spot.activityID)
                    case "fillGap":
                        appState.currentView = .fillGap(id: spot.activityID)
                    case "questionAnswers":
                        appState.currentView = .questionAnswer(id: spot.activityID)
                    case "takePhotos":
                        appState.currentView = .takePhoto(id: spot.activityID)
                    default:
                        print("Tipo de actividad no soportado: \(spot.activityType)")
                    }
                }
            }) {
                Text("Participar")
                    .font(.headline)
                    .foregroundColor(.mateWhite)
                    .padding()
                    .background(Color.mateRed)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Spacer()
        }
        .padding()
        .background(Color.mateWhite.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Aviso"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
