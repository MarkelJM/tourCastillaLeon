//
//  Map3DCallOutView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 3/9/24.
//


/*
import SwiftUI

struct Map3DCallOutView: View {
    var spot: Spot?
    var reward: ChallengeReward?
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: Map3DViewModel
    @State private var showCompletedAlert = false

    var body: some View {
        VStack(spacing: 20) {
            if let reward = reward {
                RewardView(reward: reward)
            } else if let spot = spot {
                SpotView(spot: spot)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    @ViewBuilder
    private func RewardView(reward: ChallengeReward) -> some View {
        Text(reward.challengeTitle)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.yellow)
        
        Text(reward.abstract)
            .font(.body)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        
        AsyncImage(url: URL(string: reward.prizeImage)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
        } placeholder: {
            ProgressView()
                .frame(width: 100, height: 100)
        }
        
        Button(action: {
            appState.currentView = .challengeReward(challengeName: reward.challenge)
        }) {
            Text("Obtener Recompensa")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }

    @ViewBuilder
    private func SpotView(spot: Spot) -> some View {
        Text(spot.name)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.red)
        
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
                showCompletedAlert = true
            } else {
                viewModel.saveSpotID(spot.id)
                navigateToActivity(for: spot)
            }
        }) {
            Text("Participar")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .alert(isPresented: $showCompletedAlert) {
            Alert(
                title: Text("Aviso"),
                message: Text("Tarea ya completada."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func navigateToActivity(for spot: Spot) {
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
}
*/
