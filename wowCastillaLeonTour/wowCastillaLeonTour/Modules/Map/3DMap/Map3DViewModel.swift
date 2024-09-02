//
//  Map3DViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import Combine
import MapboxMaps

class Map3DViewModel: MapViewModel {
    @Published var mapView: MapView?
    private var pointAnnotationManager: PointAnnotationManager?

    override init(appState: AppState) {
        super.init(appState: appState)
    }

    func configureMap3D(mapView: MapView) {
        self.mapView = mapView
        
        // Configurar el estilo del mapa
        try? mapView.mapboxMap.loadStyleURI(.streets)
        
        // Crear el PointAnnotationManager
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        
        // Añadir anotaciones 3D basadas en los spots
        fetchSpotsAndAddToMap3D()
    }

    private func fetchSpotsAndAddToMap3D() {
        fetchSpots()
        addSpotsToMap(spots: self.spots)  // Pasar los spots obtenidos al método de mapeo
    }

    override func addSpotsToMap(spots: [Spot]) {
        guard let pointAnnotationManager = pointAnnotationManager else { return }
        
        let annotations = spots.map { spot -> PointAnnotation in
            let unifiedAnnotation = UnifiedAnnotation(spot: spot)
            return unifiedAnnotation.toPointAnnotation() // Convertir cada spot en PointAnnotation
        }

        pointAnnotationManager.annotations = annotations
    }

    func handleTap(on annotation: PointAnnotation) {
        if let spot = spots.first(where: {
            $0.coordinates.latitude == annotation.point.coordinates.latitude &&
            $0.coordinates.longitude == annotation.point.coordinates.longitude
        }) {
            print("Spot selected: \(spot.name)")
            // Aquí se puede manejar la lógica adicional, como mostrar un callout o cambiar la vista
        }
    }
}
