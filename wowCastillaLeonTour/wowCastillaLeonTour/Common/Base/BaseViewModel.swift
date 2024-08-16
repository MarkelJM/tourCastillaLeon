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
