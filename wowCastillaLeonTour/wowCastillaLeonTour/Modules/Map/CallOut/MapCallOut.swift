//
//  MapCallOut.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/7/24.
//

import SwiftUI

struct MapCallOutView: View {
    var point: Point
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(point.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.mateRed)
            
            Text(point.abstract)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            AsyncImage(url: URL(string: point.image)) { image in
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
                if viewModel.isTaskCompleted(taskID: point.activityId, activityType: point.activityType) {
                    viewModel.alertMessage = "Esta tarea ya está completada."
                    viewModel.showAlert = true
                } else {
                    print("Participar button tapped for \(point.name)")
                    switch point.activityType {
                    case "puzzles":
                        appState.currentView = .puzzle(id: point.activityId)
                    case "coins":
                        appState.currentView = .coin(id: point.activityId)
                    case "dates":
                        appState.currentView = .dates(id: point.activityId)
                    case "fillGap":
                        appState.currentView = .fillGap(id: point.activityId)
                    case "questionAnswers":
                        appState.currentView = .questionAnswer(id: point.activityId)
                    case "takePhotos":
                        appState.currentView = .takePhoto(id: point.activityId)
                    default:
                        print("Tipo de actividad no soportado: \(point.activityType)")
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
/*
#Preview {
    MapCallOutView(point: <#Point#>)
}
*/
