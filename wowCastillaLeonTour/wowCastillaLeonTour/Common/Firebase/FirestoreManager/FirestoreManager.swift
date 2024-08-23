//
//  FirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirestoreManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // Create user profile in Firestore
    func createUserProfile(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            let userData = user.toFirestoreData()
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Fetch user profile from Firestore
    func fetchUserProfile() -> AnyPublisher<User, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    if let user = User(from: data) {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserTaskIDs(taskID: String, activityType: String, city: String?) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    var data = document.data() ?? [:]
                    var taskIDs = data["taskIDs"] as? [String] ?? []
                    
                    // Update based on city or activity type
                    if let city = city {
                        var cityTaskIDs = data["\(city)CityTaskIDs"] as? [String] ?? []
                        if !cityTaskIDs.contains(taskID) {
                            cityTaskIDs.append(taskID)
                        }
                        data["\(city)CityTaskIDs"] = cityTaskIDs
                    } else {
                        switch activityType {
                        case "coin":
                            var coinTaskIDs = data["coinTaskIDs"] as? [String] ?? []
                            if !coinTaskIDs.contains(taskID) {
                                coinTaskIDs.append(taskID)
                            }
                            data["coinTaskIDs"] = coinTaskIDs
                        case "gadget":
                            var gadgetTaskIDs = data["gadgetTaskIDs"] as? [String] ?? []
                            if !gadgetTaskIDs.contains(taskID) {
                                gadgetTaskIDs.append(taskID)
                            }
                            data["gadgetTaskIDs"] = gadgetTaskIDs
                        default:
                            if !taskIDs.contains(taskID) {
                                taskIDs.append(taskID)
                            }
                            data["taskIDs"] = taskIDs
                        }
                    }
                    
                    userRef.setData(data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Register new user with FirebaseAuth
    func registerUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Send email verification
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.currentUser?.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Check email verification status
    func checkEmailVerification() -> AnyPublisher<Bool, Error> {
        Future { promise in
            self.auth.currentUser?.reload { error in
                if let error = error {
                    promise(.failure(error))
                } else if let isVerified = self.auth.currentUser?.isEmailVerified {
                    promise(.success(isVerified))
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to check email verification"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Login user with FirebaseAuth
    func loginUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserProfile(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            let userData = user.toFirestoreData() // Asegúrate de que el método 'toFirestoreData' esté implementado en tu modelo de usuario

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Método para restablecer la contraseña
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
