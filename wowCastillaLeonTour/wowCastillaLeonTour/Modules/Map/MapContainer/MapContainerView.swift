//
//  MapContainerView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 2/9/24.
//

import SwiftUI

struct MapContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var is3DView = false
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @StateObject private var viewModel = Map3DViewModel(appState: AppState()) // Crear instancia del ViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                CustomTabBar(selectedTab: $appState.currentView)
                    .padding(.top, 100)
                    .zIndex(1)

                if is3DView {
                    Map3DView(selectedSpot: $selectedSpot, selectedReward: $selectedReward, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Map2DView()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .padding(.bottom, 10)

            Button(action: {
                is3DView.toggle()
            }) {
                Text(is3DView ? "Cambiar a 2D" : "Cambiar a 3D")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
            }
            .padding(.bottom, 200)

            // Aquí se muestran los sheets en base a la selección
            .sheet(item: $selectedSpot) { spot in
                MapCallOutView(spot: spot, viewModel: viewModel)
                    .environmentObject(appState)
            }
            .sheet(item: $selectedReward) { reward in
                CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                    .environmentObject(appState)
            }
        }
    }
}
