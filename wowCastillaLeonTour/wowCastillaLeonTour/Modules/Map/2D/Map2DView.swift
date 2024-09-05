//
//  MapView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//


import SwiftUI
import MapKit

struct Map2DView: View {
    @StateObject private var viewModel = MapViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

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
                    Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.mapAnnotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            VStack {
                                if let reward = annotation.reward {
                                    Image(systemName: "trophy.circle.fill")
                                        .resizable()
                                        .foregroundColor(.yellow)
                                        .frame(width: 40, height: 40)
                                        .onTapGesture {
                                            selectedReward = reward
                                        }
                                } else if viewModel.isTaskCompleted(spotID: annotation.spot?.id ?? "") {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        )
                                        .onTapGesture {
                                            selectedSpot = annotation.spot
                                        }
                                } else {
                                    AsyncImage(url: URL(string: annotation.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .onTapGesture {
                                        selectedSpot = annotation.spot
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        viewModel.checkChallengeStatus()
                        if viewModel.isChallengeBegan {
                            viewModel.fetchSpots()
                        }
                    }
                    .sheet(item: $selectedSpot) { spot in
                        MapCallOutView(spot: spot, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    .sheet(item: $selectedReward) { reward in
                        CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 100) // Padding adicional en la parte inferior
            .padding()
        }
        .sheet(isPresented: $viewModel.showChallengeSelection) {
            ChallengeSelectionView(viewModel: viewModel)
        }
    }
}




/*
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
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
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.mapAnnotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            if let reward = annotation.reward {
                                Image(systemName: "trophy.circle.fill")
                                    .resizable()
                                    .foregroundColor(.yellow)
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        selectedReward = reward
                                    }
                            } else if viewModel.isTaskCompleted(spotID: annotation.spot?.id ?? "") {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                    )
                                    .onTapGesture {
                                        selectedSpot = annotation.spot
                                    }
                            } else {
                                AsyncImage(url: URL(string: annotation.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                .onTapGesture {
                                    selectedSpot = annotation.spot
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.checkChallengeStatus()
                    if viewModel.isChallengeBegan {
                        viewModel.fetchSpots()
                    }
                }
                .sheet(item: $selectedSpot) { spot in
                    MapCallOutView(spot: spot, viewModel: viewModel)
                        .environmentObject(appState)
                }
                .sheet(item: $selectedReward) { reward in
                    CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                        .environmentObject(appState)
                }

                Button(action: {
                    viewModel.showChallengeSelectionView()
                }) {
                    Text("Seleccionar Reto")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                        .padding(.bottom, 150)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showChallengeSelection) {
            ChallengeSelectionView(viewModel: viewModel)
        }
    }
}
*/
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
