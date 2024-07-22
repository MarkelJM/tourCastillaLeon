//
//  NavigationState.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import SwiftUI

struct NavigationState: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        currentView()
            .environmentObject(appState)
    }
    
    @ViewBuilder
    private func currentView() -> some View {
        switch appState.currentView {
        case .registerEmail:
            RegisterView()
        case .emailVerification:
            VerificationEmailView(viewModel: RegisterViewModel())
        case .login:
            LoginView()
        case .profile:
            ProfileView()
        case .map:
            MapView()
        case .avatarSelection:
            AvatarSelectionView(selectedAvatar: .constant(.boy))
        case .puzzle(let id):
            PuzzleView(viewModel: PuzzleViewModel(activityId: id))
        case .coin(let id):
            CoinView(viewModel: CoinViewModel(activityId: id))
        case .dates(let id):
            DatesView(viewModel: DatesViewModel(activityId: id))
        case .fillGap(let id):
            FillGapView(viewModel: FillGapViewModel(activityId: id))
        case .questionAnswer(let id):
            QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: id))
        case .takePhoto(let id):
            TakePhotoView(viewModel: TakePhotoViewModel(activityId: id))
        }
    }
}
