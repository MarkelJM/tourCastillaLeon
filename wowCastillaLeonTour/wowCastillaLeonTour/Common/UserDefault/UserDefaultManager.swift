//
//  UserDefaultManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 25/8/24.
//

import Foundation

class UserDefaultsManager {
    private let spotIDKey = "spotID"
    
    // Guardar el ID del spot en UserDefaults
    func saveSpotID(_ id: String) {
        UserDefaults.standard.set(id, forKey: spotIDKey)
    }
    
    // Obtener el ID del spot desde UserDefaults
    func getSpotID() -> String? {
        return UserDefaults.standard.string(forKey: spotIDKey)
    }
    
    // Eliminar el ID del spot desde UserDefaults
    func clearSpotID() {
        UserDefaults.standard.removeObject(forKey: spotIDKey)
    }
}
