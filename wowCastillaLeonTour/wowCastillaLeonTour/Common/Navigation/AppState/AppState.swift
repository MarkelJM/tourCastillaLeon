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
        
    }
}
