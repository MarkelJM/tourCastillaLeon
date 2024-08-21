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
        Group {
            if shouldShowTabBar {
                MainTabView()
                    .environmentObject(appState)
            } else {
                currentView()
                    .environmentObject(appState)
            }
        }
        .onAppear {
            print("Current AppState in NavigationState: \(appState.currentView)")
        }
    }
    
    @ViewBuilder
    private func currentView() -> some View {
        switch appState.currentView {
        case .registerEmail:
            RegisterView(viewModel: RegisterViewModel())
        case .emailVerification:
            VerificationEmailView(viewModel: RegisterViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .profile:
            ProfileView(viewModel: ProfileViewModel())
        case .map:
            MapView()
        case .avatarSelection:
            AvatarSelectionView(selectedAvatar: .constant(.boy))
        case .puzzle(let id):
            PuzzleView(viewModel: PuzzleViewModel(activityId: id))
        case .coin(let id):
            CoinView(viewModel: CoinViewModel(activityId: id))
        case .dates(let id):
            DatesOrderView(viewModel: DatesOrderViewModel(activityId: id))
        case .fillGap(let id):
            FillGapView(viewModel: FillGapViewModel(activityId: id))
        case .questionAnswer(let id):
            QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: id))
        case .takePhoto(let id):
            TakePhotoView(viewModel: TakePhotoViewModel(activityId: id))
        case .specialPrize(let id):
            SpecialPrizeTaskView(viewModel: SpecialPrizeTaskViewModel(prizeId: id))
        }
    }
    
    private var shouldShowTabBar: Bool {
        switch appState.currentView {
        case .map:
            return true
        default:
            return false
        }
    }
}

struct NavigationState_Previews: PreviewProvider {
    static var previews: some View {
        NavigationState()
            .environmentObject(AppState())
    }
}
