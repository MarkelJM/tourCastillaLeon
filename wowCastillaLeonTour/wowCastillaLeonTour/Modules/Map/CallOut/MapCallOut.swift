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

    var body: some View {
        VStack(spacing: 20) {
            Text(point.name)
                .font(.title2)
                .fontWeight(.bold)

            AsyncImage(url: URL(string: point.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }

            Text(point.abstract) 
                .font(.body)
                .padding()

            Button(action: {
                navigateToActivity()
            }) {
                Text("Participar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }

    func navigateToActivity() {
        switch point.activityType {
        case "puzzle":
            appState.currentView = .puzzle(id: point.activityId)
        case "coin":
            appState.currentView = .coin(id: point.activityId)
        case "dates":
            appState.currentView = .dates(id: point.activityId)
        case "fillGap":
            appState.currentView = .fillGap(id: point.activityId)
        case "questionAnswer":
            appState.currentView = .questionAnswer(id: point.activityId)
        case "takePhoto":
            appState.currentView = .takePhoto(id: point.activityId)
        default:
            print("Tipo de actividad no soportado: \(point.activityType)")
        }
    }
}
/*
#Preview {
    MapCallOutView(point: <#Point#>)
}
*/
