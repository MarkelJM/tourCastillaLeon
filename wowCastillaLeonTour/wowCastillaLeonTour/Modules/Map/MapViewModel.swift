//
//  MapViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

class MapViewModel: ObservableObject {
    @Published var points: [Point] = []
    @Published var errorMessage: String?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion

    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var dataManager = MapDataManager()
    
    init() {
        // Inicializar la región para Castilla y León
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6528, longitude: -4.7286), // Centro aproximado de Castilla y León
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        setupBindings()
    }
    
    private func setupBindings() {
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.fetchPoints()
                } else if status == .denied {
                    self?.errorMessage = "Location permissions denied."
                }
            }
            .store(in: &cancellables)
        
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
            .store(in: &cancellables)
    }
    
    func fetchPoints() {
        dataManager.fetchPoints()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] points in
                self?.points = points
            }
            .store(in: &cancellables)
    }
}
