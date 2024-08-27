//
//  BaseViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/7/24.
//

import Combine
import FirebaseFirestore

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let firestoreManager = FirestoreManager()
    var cancellables = Set<AnyCancellable>()
    let userDefaultsManager = UserDefaultsManager()
    
    func fetchUserProfile() {
        firestoreManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateUserTaskIDs(taskID: String, activityType: String, city: String? = nil, challenge: String) {
        guard var user = user else { return }
        
        if isTaskAlreadyCompleted(taskID: taskID, activityType: activityType, city: city, challenge: challenge, user: user) {
            alertMessage = "Esta tarea ya está completada."
            showAlert = true
            return
        }

        // Añadir la tarea al reto específico
        if user.challenges[challenge] != nil {
            user.challenges[challenge]?.append(taskID)
        } else {
            user.challenges[challenge] = [taskID]
        }

        // Reasignar el usuario modificado a la propiedad 'user'
        self.user = user
        
        updateTaskForUser(taskID: taskID, challenge: challenge)
        updateSpotForUser()
    }

    private func updateTaskForUser(taskID: String, challenge: String) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, challenge: challenge)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error actualizando la tarea: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User task updated in Firestore")
            }
            .store(in: &cancellables)
    }

    private func updateSpotForUser() {
        // Actualizar spotID si existe
        if let spotID = userDefaultsManager.getSpotID() {
            firestoreManager.updateUserSpotIDs(spotID: spotID)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error actualizando el spot: \(error.localizedDescription)"
                        self.showAlert = true
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("User spot updated in Firestore")
                }
                .store(in: &cancellables)

            userDefaultsManager.clearSpotID() // Limpiar el spotID después de actualizarlo
        } else {
            print("No spotID found in UserDefaults")
        }
    }

    private func isTaskAlreadyCompleted(taskID: String, activityType: String, city: String?, challenge: String, user: User) -> Bool {
        return user.challenges[challenge]?.contains(taskID) ?? false
    }

    func isTaskCompleted(taskID: String, activityType: String, city: String? = nil, challenge: String) -> Bool {
        guard let user = user else { return false }
        return user.challenges[challenge]?.contains(taskID) ?? false
    }
}

/*
import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let firestoreManager = FirestoreManager()
    var cancellables = Set<AnyCancellable>()
    
    func fetchUserProfile() {
        firestoreManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateUserTaskIDs(taskID: String, activityType: String, city: String? = nil) {
        guard let user = user else { return }
        
        if isTaskAlreadyCompleted(taskID: taskID, activityType: activityType, city: city, user: user) {
            alertMessage = "Esta tarea ya está completada."
            showAlert = true
            return
        }
        
        performTaskUpdate(taskID: taskID, activityType: activityType, city: city)
    }

    private func isTaskAlreadyCompleted(taskID: String, activityType: String, city: String?, user: User) -> Bool {
        if let city = city {
            return isCityTaskCompleted(taskID: taskID, city: city, user: user)
        } else {
            return isActivityTaskCompleted(taskID: taskID, activityType: activityType, user: user)
        }
    }

    private func isCityTaskCompleted(taskID: String, city: String, user: User) -> Bool {
        switch city {
        case "Ávila": return user.avilaCityTaskIDs.contains(taskID)
        case "Burgos": return user.burgosCityTaskIDs.contains(taskID)
        case "León": return user.leonCityTaskIDs.contains(taskID)
        case "Palencia": return user.palenciaCityTaskIDs.contains(taskID)
        case "Salamanca": return user.salamancaCityTaskIDs.contains(taskID)
        case "Segovia": return user.segoviaCityTaskIDs.contains(taskID)
        case "Soria": return user.soriaCityTaskIDs.contains(taskID)
        case "Valladolid": return user.valladolidCityTaskIDs.contains(taskID)
        case "Zamora": return user.zamoraCityTaskIDs.contains(taskID)
        default: return false
        }
    }

    private func isActivityTaskCompleted(taskID: String, activityType: String, user: User) -> Bool {
        switch activityType {
        case "coin": return user.coinTaskIDs.contains(taskID)
        case "gadget": return user.gadgetTaskIDs.contains(taskID)
        default: return user.taskIDs.contains(taskID)
        }
    }

    private func performTaskUpdate(taskID: String, activityType: String, city: String?) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, activityType: activityType, city: city)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error: \(error.localizedDescription)"
                case .finished:
                    break
                    //self.alertMessage = "Tarea añadida correctamente." //no mostramos mensajes ya que superpone el mensaje que traemos de firestore con respuesta correcta
                }
                self.showAlert = true
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func isTaskCompleted(taskID: String, activityType: String, city: String? = nil) -> Bool {
        guard let user = user else { return false }
        
        if let city = city {
            switch city {
            case "Ávila":
                return user.avilaCityTaskIDs.contains(taskID)
            case "Burgos":
                return user.burgosCityTaskIDs.contains(taskID)
            case "León":
                return user.leonCityTaskIDs.contains(taskID)
            case "Palencia":
                return user.palenciaCityTaskIDs.contains(taskID)
            case "Salamanca":
                return user.salamancaCityTaskIDs.contains(taskID)
            case "Segovia":
                return user.segoviaCityTaskIDs.contains(taskID)
            case "Soria":
                return user.soriaCityTaskIDs.contains(taskID)
            case "Valladolid":
                return user.valladolidCityTaskIDs.contains(taskID)
            case "Zamora":
                return user.zamoraCityTaskIDs.contains(taskID)
            default:
                return false
            }
        }
        
        switch activityType {
        case "coin":
            return user.coinTaskIDs.contains(taskID)
        case "gadget":
            return user.gadgetTaskIDs.contains(taskID)
        default:
            return user.taskIDs.contains(taskID)
        }
    }
}
*/
