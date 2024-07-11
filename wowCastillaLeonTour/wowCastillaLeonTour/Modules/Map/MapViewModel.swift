//
//  MapViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var points: [Point] = []
    @Published var errorMessage: String?
    
    private let dataManager = MapDataManager()
    
    func fetchPoints() {
        dataManager.fetchPoints { [weak self] points in
            DispatchQueue.main.async {
                self?.points = points
            }
        } failure: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
