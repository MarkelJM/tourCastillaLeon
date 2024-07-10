//
//  RegisterDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation

class RegisterDataManager {
    private let firestoreManager = FirestoreManager()
    
    func registerUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.registerUser(email: email, password: password, completion: completion)
    }
    
    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.sendEmailVerification(completion: completion)
    }
    
    func checkEmailVerification(completion: @escaping (Result<Bool, Error>) -> Void) {
        firestoreManager.checkEmailVerification(completion: completion)
    }
}
