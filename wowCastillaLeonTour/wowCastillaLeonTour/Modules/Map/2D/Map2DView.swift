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
                    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.mapAnnotations + [viewModel.userLocationAnnotation].compactMap { $0 }) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            if annotation.isUserLocation {
                                // Muestra el avatar del usuario en su ubicación
                                Image(viewModel.user?.avatar.rawValue ?? "defaultAvatar")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            } else if let reward = annotation.reward {
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
            .padding(.bottom, 100)
            .padding()
        }
        .sheet(isPresented: $viewModel.showChallengeSelection) {
            ChallengeSelectionView(viewModel: viewModel)
        }
    }
}
