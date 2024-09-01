//
//  AppState.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentView: AppView = .icon {
        didSet {
            print("Current view is now \(currentView)")
        }
    }

    enum AppView: Equatable {
        case icon
        case registerEmail
        case emailVerification
        case login
        case profile
        case map
        case map3D
        case challengeList
        case avatarSelection
        case puzzle(id: String)
        case coin(id: String)
        case dates(id: String)
        case fillGap(id: String)
        case questionAnswer(id: String)
        case takePhoto(id: String)
        //case specialPrize(id: String) 
        case onboardingOne
        case onboardingTwo   
        case forgotPassword
        case termsAndConditions
        case challengePresentation(challengeName: String)
        case settings
        case challengeReward(challengeName: String)  // Añadir este caso para la vista de recompensa

    }
}
