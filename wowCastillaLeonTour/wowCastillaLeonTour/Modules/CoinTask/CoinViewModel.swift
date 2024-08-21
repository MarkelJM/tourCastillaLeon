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
        
        // Mostrar el mensaje personalizado desde Firestore
        self.resultMessage = coin.description
        self.showResultModal = true
    }
}

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
