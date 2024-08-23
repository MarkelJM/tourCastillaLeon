//
//  BaseViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/7/24.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let firestoreManager = FirestoreManager()
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
        guard var user = user else { return }  // Usar 'var' para hacer mutable la copia de 'user'
        
        if isTaskAlreadyCompleted(taskID: taskID, activityType: activityType, city: city, user: user) {
            alertMessage = "Esta tarea ya está completada."
            showAlert = true
            return
        }
        
        // Añadir la tarea al array de la provincia correspondiente
        if let city = city {
            switch city {
            case "Ávila":
                user.avilaCityTaskIDs.append(taskID)
            case "Burgos":
                user.burgosCityTaskIDs.append(taskID)
            case "León":
                user.leonCityTaskIDs.append(taskID)
            case "Palencia":
                user.palenciaCityTaskIDs.append(taskID)
            case "Salamanca":
                user.salamancaCityTaskIDs.append(taskID)
            case "Segovia":
                user.segoviaCityTaskIDs.append(taskID)
            case "Soria":
                user.soriaCityTaskIDs.append(taskID)
            case "Valladolid":
                user.valladolidCityTaskIDs.append(taskID)
            case "Zamora":
                user.zamoraCityTaskIDs.append(taskID)
            default:
                break
            }
        }
        
        // Añadir la tarea al array general de taskIDs
        user.taskIDs.append(taskID)
        
        // Reasignar el usuario modificado a la propiedad 'user'
        self.user = user
        
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
                    self.alertMessage = "Tarea añadida correctamente."
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
