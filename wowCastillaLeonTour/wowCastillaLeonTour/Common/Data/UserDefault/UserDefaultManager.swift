//
//  UserDefaultManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 25/8/24.
//

import Foundation

class UserDefaultsManager {
    private let spotIDKey = "spotID"
    private let challengeNameKey = "challengeName"
    private let soundEnabledKey = "soundEnabled"
    
    // Método para guardar la preferencia de sonido
    func setSoundEnabled(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: soundEnabledKey)
    }
    
    // Método para obtener la preferencia de sonido
    func isSoundEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: soundEnabledKey)
    }


    func saveSpotID(_ id: String) {
        UserDefaults.standard.set(id, forKey: spotIDKey)
    }

    func getSpotID() -> String? {
        return UserDefaults.standard.string(forKey: spotIDKey)
    }

    func clearSpotID() {
        UserDefaults.standard.removeObject(forKey: spotIDKey)
    }

    func saveChallengeName(_ name: String) {
        UserDefaults.standard.set(name, forKey: challengeNameKey)
    }

    func getChallengeName() -> String? {
        return UserDefaults.standard.string(forKey: challengeNameKey)
    }

    func clearChallengeName() {
        UserDefaults.standard.removeObject(forKey: challengeNameKey)
    }
}
