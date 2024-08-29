//
//  MapView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.authorizationStatus == .notDetermined {
                Text("Requesting location permissions...")
            } else if viewModel.authorizationStatus == .denied {
                Text("Location permissions denied.")
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.spots) { spot in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: spot.coordinates.latitude, longitude: spot.coordinates.longitude)) {
                        VStack {
                            AsyncImage(url: URL(string: spot.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(
                                        spot.isCompleted ? Circle().stroke(Color.green, lineWidth: 3) : nil
                                    )
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .onTapGesture {
                            selectedSpot = spot
                        }
                    }
                }
                .onAppear {
                    viewModel.checkChallengeStatus()
                    if viewModel.isChallengeBegan {
                        viewModel.fetchSpots()
                    } else {
                        viewModel.showChallengeSelection = true
                    }
                }
                .sheet(item: $selectedSpot) { spot in
                    MapCallOutView(spot: spot, viewModel: viewModel)
                        .environmentObject(appState)
                }

                // Botón para mostrar la selección de retos manualmente
                Button(action: {
                    viewModel.showChallengeSelection.toggle()
                }) {
                    Text("Seleccionar Reto")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showChallengeSelection) {
            ChallengeSelectionView(viewModel: viewModel)
                .environmentObject(appState)
        }
    }
}

/*
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedPoint: Point?
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.authorizationStatus == .notDetermined {
                Text("Requesting location permissions...")
            } else if viewModel.authorizationStatus == .denied {
                Text("Location permissions denied.")
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.points) { point in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude)) {
                        VStack {
                            AsyncImage(url: URL(string: point.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .onTapGesture {
                            selectedPoint = point
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPoints()
                }
                .sheet(item: $selectedPoint) { point in
                    MapCallOutView(point: point, viewModel: viewModel) // Pasar el viewModel al MapCallOutView
                        .environmentObject(appState) // Pasar appState si es necesario
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppState())
}
 
 */

/*
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedPoint: Point?

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.authorizationStatus == .notDetermined {
                Text("Requesting location permissions...")
            } else if viewModel.authorizationStatus == .denied {
                Text("Location permissions denied.")
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.points) { point in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude)) {
                        VStack {
                            AsyncImage(url: URL(string: point.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .onTapGesture {
                            selectedPoint = point
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPoints()
                }
                .sheet(item: $selectedPoint) { point in
                    MapCallOutView(point: point)
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppState())
}
*/
