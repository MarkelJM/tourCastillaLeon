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
            case .puzzle:
                PuzzleView()
                    
            }
        }
    }
}


