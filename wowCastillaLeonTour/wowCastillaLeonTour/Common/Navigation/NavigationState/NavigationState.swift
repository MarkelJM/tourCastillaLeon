//
//  NavigationState.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//




import SwiftUI

struct NavigationState: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var registerViewModel = RegisterViewModel()

    var body: some View {
        VStack {
            currentView() // Mostrar la vista actual según el estado

            Spacer()

            // Barra de navegación personalizada en la parte inferior
            HStack {
                Button(action: {
                    appState.currentView = .challengeList
                }) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Desafíos")
                    }
                }
                Spacer()

                Button(action: {
                    appState.currentView = .map
                }) {
                    VStack {
                        Image(systemName: "map")
                        Text("Mapa")
                    }
                }
                Spacer()

                Button(action: {
                    appState.currentView = .profile
                }) {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Perfil")
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
        .onAppear {
            print("Current AppState in NavigationState: \(appState.currentView)")
        }
    }

    @ViewBuilder
    private func currentView() -> some View {
        switch appState.currentView {
        case .icon:
            IconView()
        case .registerEmail:
            RegisterView(viewModel: registerViewModel)
        case .emailVerification:
            VerificationEmailView(viewModel: RegisterViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .profile:
            ProfileView(viewModel: ProfileViewModel())
        case .map:
            MapView()
        case .challengeList:
            ChallengeListView()
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
        
        case .onboardingOne:
             OnboardingOneView()
         case .onboardingTwo:
             OnboardingTwoView()
        case .forgotPassword:
            ForgotPasswordView(viewModel: ForgotPasswordViewModel())
        case .termsAndConditions:
              TermsAndConditionsView(agreeToTerms: $registerViewModel.agreeToTerms)
        case .challengePresentation(let challengeName):
            ChallengePresentationView(viewModel: ChallengePresentationViewModel(challengeName: challengeName))
        }
    }
}

struct NavigationState_Previews: PreviewProvider {
    static var previews: some View {
        NavigationState()
            .environmentObject(AppState())
    }
}



/*
import SwiftUI

struct NavigationState: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var registerViewModel = RegisterViewModel()

    var body: some View {
        Group {
            if shouldShowTabBar {
                MainTabView()  // No pasamos el binding aquí
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
        case .icon:
            IconView()
        case .registerEmail:
            RegisterView(viewModel: registerViewModel)
        case .emailVerification:
            VerificationEmailView(viewModel: RegisterViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .profile:
            ProfileView(viewModel: ProfileViewModel())
        case .map:
            MapView()
        case .challengeList:
            ChallengeListView()  // No pasamos el binding aquí
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
        
        case .onboardingOne:
             OnboardingOneView()
         case .onboardingTwo:
             OnboardingTwoView()
        case .forgotPassword:
            ForgotPasswordView(viewModel: ForgotPasswordViewModel())
        case .termsAndConditions:
              TermsAndConditionsView(agreeToTerms: $registerViewModel.agreeToTerms)
        case .challengePresentation(let challengeName):
            ChallengePresentationView(viewModel: ChallengePresentationViewModel(challengeName: challengeName))
        }
    }
    
    private var shouldShowTabBar: Bool {
        // Determinamos cuándo se debe mostrar el TabBar
        switch appState.currentView {
        case .map, .challengeList, .profile:  // Por ejemplo, mostrar en estas vistas
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
*/
