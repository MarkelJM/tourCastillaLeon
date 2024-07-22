//
//  AppState.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentView: AppView = .login {
        didSet {
            print("Current view is now \(currentView)")
        }
    }

    enum AppView {
        case registerEmail
        case emailVerification
        case login
        case profile
        case map
        case avatarSelection
        case puzzle(id: String)
        case coin(id: String)
        case dates(id: String)
        case fillGap(id: String)
        case questionAnswer(id: String)
        case takePhoto(id: String)

        
    }
}
