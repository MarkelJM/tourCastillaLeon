//
//  LoginDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation

class LoginDataManager {
    private let firestoreManager = FirestoreManager()
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.loginUser(email: email, password: password, completion: completion)
    }
}
