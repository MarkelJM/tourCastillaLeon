//
//  CoinViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//


import SwiftUI
import Combine

class CoinViewModel: BaseViewModel {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""

    private let dataManager = CoinDataManager()
    private var activityId: String
    private var appState: AppState  // Añadir esto

    init(activityId: String, appState: AppState) {  // Modificar esto
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()  // Cargar el perfil del usuario al crear el ViewModel
        fetchCoinById(activityId)
    }
    
    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func completeTask(coin: Coin) {
        // Evitar duplicados en Firestore
        guard let user = user else { return }
        
        if user.challenges[coin.challenge]?.contains(coin.id) == true {
            print("Task ID already exists, not adding again.")
            return
        }

        updateTaskForUser(taskID: coin.id, challenge: coin.challenge)
        updateSpotForUser()

        // Mostrar el mensaje personalizado desde Firestore
        self.resultMessage = coin.correctAnswerMessage
        self.showResultModal = true
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
            } receiveValue: { [weak self] _ in
                print("User task updated in Firestore")
                self?.appState.currentView = .map  // Navegar al mapa después de actualizar
            }
            .store(in: &cancellables)
    }

    private func updateSpotForUser() {
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

            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }
}



/*
import SwiftUI
import Combine

class CoinViewModel: BaseViewModel {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""

    private let dataManager = CoinDataManager()
    private var activityId: String

    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()  // Cargar el perfil del usuario al crear el ViewModel
        fetchCoinById(activityId)
    }
    
    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func completeTask(coin: Coin) {
        updateTaskForUser(taskID: coin.id, challenge: coin.challenge)
        updateSpotForUser()

        // Mostrar el mensaje personalizado desde Firestore
        self.resultMessage = coin.description
        self.showResultModal = true
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

            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }
}

*/

/*
import SwiftUI
import Combine

class CoinViewModel: BaseViewModel {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""

    private let dataManager = CoinDataManager()
    private var activityId: String

    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()  // Cargar el perfil del usuario al crear el ViewModel
        fetchCoinById(activityId)
    }
    
    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func completeTask(coin: Coin) {
        let activityType = "coin"
        var city: String? = nil
        
        if coin.isCapital {
            city = coin.province
        }
        
        // Actualizar el reto asociado al Coin completado
        let challenge = coin.challenge
        updateUserTaskIDs(taskID: coin.id, activityType: activityType, city: city, challenge: challenge)
        
        // Mostrar el mensaje personalizado desde Firestore
        self.resultMessage = coin.description
        self.showResultModal = true
    }
}
 
 */

/*
///funciona
import SwiftUI
import Combine

class CoinViewModel: BaseViewModel {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    
    private let dataManager = CoinDataManager()
    private var activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()  // Cargar el perfil del usuario al crear el ViewModel
        fetchCoinById(activityId)
    }
    
    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func completeTask(coin: Coin) {
        let activityType = "coin"
        var city: String? = nil
        
        if coin.isCapital {
            city = coin.province
        }
        
        updateUserTaskIDs(taskID: coin.id, activityType: activityType, city: city)
        showResultModal = true
    }
}
 
 
 */

/*
import SwiftUI
import Combine

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = CoinDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchCoinById(activityId)
    }

    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    

}
*/
