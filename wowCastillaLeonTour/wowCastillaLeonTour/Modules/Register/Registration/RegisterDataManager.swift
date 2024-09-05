//
//  RegisterDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//
import Foundation
import Combine

class RegisterDataManager {
    private let firestoreManager = FirestoreManager()
    
    func registerUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        firestoreManager.registerUser(email: email, password: password)
    }
    
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        firestoreManager.sendEmailVerification()
    }
    
    func checkEmailVerification() -> AnyPublisher<Bool, Error> {
        firestoreManager.checkEmailVerification()
    }
}
